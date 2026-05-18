import axios from 'axios';
import { Message } from 'element-ui';
import router from '@/router';

const service = axios.create({
  baseURL: '/api',
  timeout: 10000
});

service.interceptors.request.use(
  config => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers['Authorization'] = 'Bearer ' + token;
    }
    const userInfoStr = localStorage.getItem('userInfo');
    if (userInfoStr) {
      try {
        const userInfo = JSON.parse(userInfoStr);
        if (userInfo.role) {
          config.headers['X-User-Role'] = userInfo.role;
        }
      } catch (e) {
        console.error('解析userInfo失败:', e);
      }
    }
    return config;
  },
  error => {
    console.error('请求错误：', error);
    return Promise.reject(error);
  }
);

service.interceptors.response.use(
  response => {
    const res = response.data;
    if (res.code !== 200) {
      Message({
        message: res.msg || res.message || '请求失败',
        type: 'error',
        duration: 3000
      });

      if (res.code === 401) {
        localStorage.removeItem('token');
        localStorage.removeItem('userInfo');
        localStorage.removeItem('user');
        localStorage.removeItem('userId');
        if (router.currentRoute.path !== '/login') {
          router.push('/login').catch(() => { });
        }
      }

      return Promise.resolve(res);
    }

    return res;
  },
  error => {
    console.error('响应错误：', error);

    if (error.response) {
      switch (error.response.status) {
        case 401:
          Message({
            message: '登录已过期，请重新登录',
            type: 'error',
            duration: 3000
          });
          localStorage.removeItem('token');
          localStorage.removeItem('userInfo');
          localStorage.removeItem('user');
          localStorage.removeItem('userId');
          if (router.currentRoute.path !== '/login') {
            router.push('/login').catch(() => { });
          }
          break;
        case 403:
          Message({
            message: '没有权限访问该资源',
            type: 'error',
            duration: 3000
          });
          break;
        case 404:
          Message({
            message: '请求的资源不存在',
            type: 'error',
            duration: 3000
          });
          break;
        case 500:
          Message({
            message: '服务器错误，请稍后重试',
            type: 'error',
            duration: 3000
          });
          break;
        default:
          Message({
            message: error.response.data?.message || '请求失败',
            type: 'error',
            duration: 3000
          });
      }
    } else if (error.code === 'ECONNABORTED') {
      Message({
        message: '请求超时，请稍后重试',
        type: 'error',
        duration: 3000
      });
    } else {
      Message({
        message: '网络错误，请检查网络连接',
        type: 'error',
        duration: 3000
      });
    }

    // 返回错误，但不抛出，避免控制台显示错误
    return Promise.resolve({ code: -1, message: error.message });
  }
);

export default service;
