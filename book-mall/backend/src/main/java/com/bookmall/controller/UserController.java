package com.bookmall.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.bookmall.common.Result;
import com.bookmall.entity.User;
import com.bookmall.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

/**
 * 用户管理控制器
 */
@RestController
@RequestMapping("/user")
@CrossOrigin
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    @Autowired
    private StringRedisTemplate redisTemplate;

    @Value("${file.upload.path}")
    private String uploadPath;

    private static final long VERIFY_CODE_EXPIRE_SECONDS = 5 * 60; // 验证码5分钟有效期
    private static final long VERIFY_CODE_COOLDOWN_SECONDS = 30; // 验证码30秒冷却时间

    /**
     * 用户注册（支持用户和商家）
     *
     * @param role 注册角色：user-用户，merchant-商家
     */
    @PostMapping("/register/{role}")
    public Result<String> register(@PathVariable String role, @RequestBody User user) {
        // 验证角色只能是 user 或 merchant
        if (!"user".equals(role) && !"merchant".equals(role)) {
            return Result.error(400, "无效的注册角色");
        }

        user.setRole(role);
        if (userService.isUsernameExistsInRole(user.getUsername(), user.getRole())) {
            return Result.error(400, "该用户名已被注册");
        }

        // 对密码进行 BCrypt 加密
        user.setPassword(passwordEncoder.encode(user.getPassword()));

        boolean success = userService.save(user);
        if (success) {
            return Result.success("注册成功");
        }
        return Result.error("注册失败");
    }

    /**
     * 用户注册（默认注册为普通用户）
     */
    @PostMapping("/register")
    public Result<String> register(@RequestBody User user) {
        return register("user", user);
    }

    /**
     * 用户登录
     */
    @PostMapping("/login")
    public Result<User> login(@RequestBody User userParam) {
        // 先查询该用户名是否存在
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUsername, userParam.getUsername());

        // 管理员登录时，同时支持 admin 和 super_admin 角色
        if ("admin".equals(userParam.getRole())) {
            wrapper.and(w -> w.eq(User::getRole, "admin").or().eq(User::getRole, "super_admin"));
        } else {
            wrapper.eq(User::getRole, userParam.getRole());
        }

        User existUser = userService.getOne(wrapper);

        if (existUser == null) {
            // 用户名不存在
            return Result.error(401, "用户名未注册");
        }

        String storedPassword = existUser.getPassword();
        String inputPassword = userParam.getPassword();
        boolean passwordMatched = false;

        if (storedPassword.startsWith("$2a$") || storedPassword.startsWith("$2b$")
                || storedPassword.startsWith("$2y$")) {
            passwordMatched = passwordEncoder.matches(inputPassword, storedPassword);
        } else {
            if (inputPassword.equals(storedPassword)) {
                passwordMatched = true;
                String encryptedPassword = passwordEncoder.encode(storedPassword);
                existUser.setPassword(encryptedPassword);
                userService.updateById(existUser);
            }
        }

        if (!passwordMatched) {
            return Result.error(401, "密码错误");
        }

        // 登录成功
        existUser.setPassword(null);
        return Result.success(existUser);
    }

    /**
     * 获取所有用户列表（排除超级管理员）
     */
    @GetMapping("/list")
    public Result<Map<String, Object>> getUserList(
            @RequestParam(defaultValue = "1") Long page,
            @RequestParam(defaultValue = "10") Long pageSize,
            @RequestParam(required = false) String username,
            @RequestParam(required = false) String realName,
            @RequestParam(required = false) String phone,
            @RequestParam(required = false) String role,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String shopName,
            @RequestParam(required = false) String shopType,
            @RequestHeader(value = "X-User-Role", required = false) String currentRole) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(username != null && !username.trim().isEmpty(), User::getUsername, username);
        wrapper.like(realName != null && !realName.trim().isEmpty(), User::getRealName, realName);
        wrapper.like(phone != null && !phone.trim().isEmpty(), User::getPhone, phone);
        wrapper.eq(role != null && !role.trim().isEmpty(), User::getRole, role);
        wrapper.eq(status != null, User::getStatus, status);
        wrapper.like(shopName != null && !shopName.trim().isEmpty(), User::getShopName, shopName);
        wrapper.eq(shopType != null && !shopType.trim().isEmpty(), User::getShopType, shopType);

        // 根据当前用户角色过滤
        // 普通管理员只能看到商家和普通用户
        if (!"super_admin".equals(currentRole)) {
            wrapper.and(w -> w.ne(User::getRole, "admin").ne(User::getRole, "super_admin"));
        }

        // 自定义排序：系统管理员(super_admin) > 其他管理员(admin) > 商家/普通用户
        // 使用 CASE WHEN 实现角色优先级排序，然后按创建时间倒序
        wrapper.last(
                "ORDER BY CASE role WHEN 'super_admin' THEN 1 WHEN 'admin' THEN 2 ELSE 3 END ASC, create_time DESC");

        Page<User> userPage = userService.page(new Page<>(page, pageSize), wrapper);
        Map<String, Object> data = new HashMap<>();
        data.put("records", userPage.getRecords());
        data.put("total", userPage.getTotal());
        data.put("page", userPage.getCurrent());
        data.put("pageSize", userPage.getSize());
        return Result.success("查询成功", data);
    }

    /**
     * 根据ID获取用户信息
     */
    @GetMapping("/{id}")
    public Result<User> getUserById(@PathVariable Long id) {
        User user = userService.getById(id);
        if (user == null) {
            return Result.error("用户不存在");
        }
        return Result.success(user);
    }

    /**
     * 添加用户
     */
    @PostMapping("/add")
    public Result<String> addUser(@RequestBody User user,
            @RequestHeader(value = "X-User-Role", required = false) String currentRole) {
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            return Result.error(400, "初始密码不能为空");
        }
        if (user.getPassword().length() < 6 || user.getPassword().length() > 20) {
            return Result.error(400, "密码长度必须在6-20位之间");
        }

        if ("admin".equals(user.getRole()) && !"super_admin".equals(currentRole)) {
            return Result.error(403, "普通管理员不能添加管理员账户");
        }

        boolean success = userService.save(user);
        if (success) {
            return Result.success("用户添加成功");
        }
        return Result.error("用户添加失败");
    }

    /**
     * 更新用户信息
     */
    @PutMapping("/update")
    public Result<String> updateUser(@RequestBody User user,
            @RequestHeader(value = "X-User-Role", required = false) String currentRole) {
        User existUser = userService.getById(user.getId());
        if (existUser == null) {
            return Result.error("用户不存在");
        }

        if ("admin".equals(existUser.getRole()) || "super_admin".equals(existUser.getRole())) {
            if (!"super_admin".equals(currentRole)) {
                return Result.error(403, "普通管理员不能编辑管理员账户");
            }

            if ("admin".equals(user.getRole()) && !"super_admin".equals(currentRole)) {
                return Result.error(403, "普通管理员不能将用户角色修改为管理员");
            }

            if (user.getUsername() != null && !user.getUsername().equals(existUser.getUsername())) {
                return Result.error(403, "只有超级管理员才能修改用户名");
            }
        }

        user.setUpdateTime(null);
        boolean success = userService.updateById(user);
        if (success) {
            return Result.success("用户更新成功");
        }
        return Result.error("用户更新失败");
    }

    /**
     * 删除用户
     */
    @DeleteMapping("/{id}")
    public Result<String> deleteUser(@PathVariable Long id,
            @RequestHeader(value = "X-User-Role", required = false) String currentRole) {
        User existUser = userService.getById(id);
        if (existUser == null) {
            return Result.error("用户不存在");
        }
        if ("admin".equals(existUser.getRole()) && !"super_admin".equals(currentRole)) {
            return Result.error(403, "普通管理员不能删除其他管理员账户");
        }
        boolean success = userService.removeById(id);
        if (success) {
            return Result.success("用户删除成功");
        }
        return Result.error("用户删除失败");
    }

    /**
     * 更新用户个人信息
     */
    @PutMapping("/profile")
    public Result<String> updateProfile(@RequestBody User user) {
        User existUser = userService.getById(user.getId());
        if (existUser == null) {
            return Result.error("用户不存在");
        }

        if (user.getUsername() != null && !user.getUsername().equals(existUser.getUsername())) {
            boolean usernameExists = userService.lambdaQuery()
                    .eq(User::getUsername, user.getUsername())
                    .eq(User::getRole, "user")
                    .ne(User::getId, user.getId())
                    .exists();
            if (usernameExists) {
                return Result.error("该用户名已被使用");
            }
            existUser.setUsername(user.getUsername());
        }

        existUser.setRealName(user.getRealName());
        existUser.setPhone(user.getPhone());
        existUser.setEmail(user.getEmail());
        existUser.setAvatar(user.getAvatar());
        existUser.setGender(user.getGender());
        existUser.setAge(user.getAge());

        boolean success = userService.updateById(existUser);
        if (success) {
            return Result.success("保存成功");
        }
        return Result.error("保存失败");
    }

    /**
     * 修改密码
     */
    @PutMapping("/password")
    public Result<String> changePassword(@RequestBody Map<String, String> params) {
        Long userId = Long.parseLong(params.get("userId"));
        String oldPassword = params.get("oldPassword");
        String newPassword = params.get("newPassword");

        User user = userService.getById(userId);
        if (user == null) {
            return Result.error("用户不存在");
        }

        if (!user.getPassword().equals(oldPassword)) {
            return Result.error("原密码错误");
        }

        user.setPassword(newPassword);
        boolean success = userService.updateById(user);
        if (success) {
            return Result.success("密码修改成功");
        }
        return Result.error("密码修改失败");
    }

    /**
     * 重置用户密码（管理员操作，不需要验证旧密码）
     */
    @PostMapping("/reset-password")
    public Result<?> resetPassword(@RequestBody Map<String, String> params,
            @RequestHeader(value = "X-User-Role", required = false) String currentRole) {
        Long userId = Long.parseLong(params.get("userId"));
        String newPassword = params.get("newPassword");

        if (newPassword == null || newPassword.trim().isEmpty()) {
            return Result.error("新密码不能为空");
        }

        if (newPassword.length() < 6 || newPassword.length() > 20) {
            return Result.error("密码长度必须在6-20位之间");
        }

        User user = userService.getById(userId);
        if (user == null) {
            return Result.error("用户不存在");
        }

        if ("admin".equals(user.getRole()) && !"super_admin".equals(currentRole)) {
            return Result.error(403, "普通管理员不能重置其他管理员的密码");
        }

        user.setPassword(newPassword);
        userService.updateById(user);

        return Result.success("密码重置成功");
    }

    /**
     * 检查用户名是否可用
     */
    @GetMapping("/check-username")
    public Result<Boolean> checkUsername(@RequestParam String username,
            @RequestParam(required = false) Long excludeId) {
        boolean exists = userService.lambdaQuery()
                .eq(User::getUsername, username)
                .eq(User::getRole, "user")
                .ne(excludeId != null, User::getId, excludeId)
                .exists();
        return Result.success(!exists);
    }

    /**
     * 获取管理员联系方式（用于客服页面）
     */
    @GetMapping("/admin-contact")
    public Result<Map<String, String>> getAdminContact() {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getRole, "admin").or().eq(User::getRole, "super_admin");
        wrapper.last("LIMIT 1");
        User admin = userService.getOne(wrapper);

        Map<String, String> contact = new HashMap<>();
        contact.put("email", admin != null && admin.getEmail() != null ? admin.getEmail() : "admin@bookmall.com");
        contact.put("phone", admin != null && admin.getPhone() != null ? admin.getPhone() : "400-888-8888");
        return Result.success(contact);
    }

    /**
     * 检测用户密码（尝试常见密码匹配）
     */
    @GetMapping("/check-password/{id}")
    public Result<Map<String, Object>> checkPassword(@PathVariable Long id) {
        User user = userService.getById(id);
        if (user == null) {
            return Result.error("用户不存在");
        }

        String storedPassword = user.getPassword();
        Map<String, Object> result = new HashMap<>();
        result.put("username", user.getUsername());
        result.put("found", false);
        result.put("matchedPassword", null);

        // 常见密码列表
        String[] commonPasswords = { "123456", "123456789", "12345678", "12345",
                "password", "1234567", "123123", "admin123", "merchant123",
                "111111", "666666", "888888", "123321", "qwerty", "abc123" };

        // 尝试常见密码
        for (String testPassword : commonPasswords) {
            if (storedPassword.equals(testPassword)) {
                result.put("found", true);
                result.put("matchedPassword", testPassword);
                return Result.success(result);
            }
            if (storedPassword.startsWith("$2") && passwordEncoder.matches(testPassword, storedPassword)) {
                result.put("found", true);
                result.put("matchedPassword", testPassword);
                return Result.success(result);
            }
        }

        // 如果是明文存储，尝试获取
        if (!storedPassword.startsWith("$2")) {
            result.put("found", true);
            result.put("matchedPassword", storedPassword);
            result.put("isPlainText", true);
        }

        return Result.success(result);
    }

    /**
     * 上传用户头像
     */
    @PostMapping("/upload-avatar")
    public Result<String> uploadAvatar(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            return Result.error("请选择要上传的文件");
        }

        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null || !originalFilename.matches(".*\\.(jpg|jpeg|png|gif)$")) {
            return Result.error("只能上传图片文件（jpg、jpeg、png、gif）");
        }

        if (file.getSize() > 5 * 1024 * 1024) {
            return Result.error("文件大小不能超过5MB");
        }

        String uploadDir = uploadPath + "/avatar/";
        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        String newFilename = UUID.randomUUID().toString() +
                originalFilename.substring(originalFilename.lastIndexOf("."));
        String filePath = uploadDir + newFilename;

        try {
            file.transferTo(new File(filePath));
            String avatarUrl = "/avatar/" + newFilename;
            return Result.success("头像上传成功", avatarUrl);
        } catch (IOException e) {
            return Result.error("上传失败：" + e.getMessage());
        }
    }

    /**
     * 发送验证码
     * 
     * @param phone 手机号
     * @param type  验证码类型：change_phone-更换手机号
     */
    @PostMapping("/send-verify-code")
    public Result<String> sendVerifyCode(@RequestBody Map<String, String> params) {
        String phone = params.get("phone");
        String type = params.get("type");

        if (phone == null || phone.trim().isEmpty()) {
            return Result.error("手机号不能为空");
        }

        if (!phone.matches("^1[3-9]\\d{9}$")) {
            return Result.error("请输入正确的手机号");
        }

        if (type == null || type.trim().isEmpty()) {
            return Result.error("验证码类型不能为空");
        }

        String cacheKey = "verify_code:" + phone + "_" + type;
        String cooldownKey = "verify_code_cooldown:" + phone + "_" + type;

        String remainingSecondsStr = redisTemplate.opsForValue().get(cooldownKey);
        if (remainingSecondsStr != null) {
            long remainingSeconds = Long.parseLong(remainingSecondsStr);
            return Result.error("请 " + remainingSeconds + " 秒后再试");
        }

        String verifyCode = String.format("%06d", new Random().nextInt(1000000));

        String codeInfo = verifyCode;
        redisTemplate.opsForValue().set(cacheKey, codeInfo, VERIFY_CODE_EXPIRE_SECONDS, TimeUnit.SECONDS);
        redisTemplate.opsForValue().set(cooldownKey, String.valueOf(VERIFY_CODE_COOLDOWN_SECONDS),
                VERIFY_CODE_COOLDOWN_SECONDS, TimeUnit.SECONDS);

        System.out.println("========== 验证码(开发调试) ==========");
        System.out.println("手机号: " + phone);
        System.out.println("类型: " + type);
        System.out.println("验证码: " + verifyCode);
        System.out.println("有效期: 5分钟");
        System.out.println("======================================");

        return Result.success("验证码已发送");
    }

    /**
     * 更换手机号
     * 
     * @param params 包含 userId, newPhone, verifyCode
     */
    @PutMapping("/update-phone")
    public Result<String> updatePhone(@RequestBody Map<String, String> params) {
        String userIdStr = params.get("userId");
        String newPhone = params.get("newPhone");
        String verifyCode = params.get("verifyCode");

        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            return Result.error("用户ID不能为空");
        }

        if (newPhone == null || newPhone.trim().isEmpty()) {
            return Result.error("新手机号不能为空");
        }

        if (!newPhone.matches("^1[3-9]\\d{9}$")) {
            return Result.error("请输入正确的新手机号");
        }

        if (verifyCode == null || verifyCode.trim().isEmpty()) {
            return Result.error("验证码不能为空");
        }

        Long userId = null;
        try {
            userId = Long.parseLong(userIdStr);
        } catch (NumberFormatException e) {
            return Result.error("无效的用户ID");
        }

        User user = userService.getById(userId);
        if (user == null) {
            return Result.error("用户不存在");
        }

        if (newPhone.equals(user.getPhone())) {
            return Result.error("新手机号不能与原手机号相同");
        }

        String cacheKey = "verify_code:" + newPhone + "_change_phone";
        String storedCode = redisTemplate.opsForValue().get(cacheKey);

        if (storedCode == null) {
            return Result.error("验证码已过期，请重新获取");
        }

        if (!storedCode.equals(verifyCode)) {
            return Result.error("验证码错误");
        }

        redisTemplate.delete(cacheKey);

        user.setPhone(newPhone);
        userService.updateById(user);

        return Result.success("手机号更换成功");
    }
}
