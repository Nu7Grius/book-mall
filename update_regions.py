import json

output_path = 'd:/CommonDataAndInformation/永远期待/永远期待2.0/AI时代/全栈学习计划——书魂管理系统及微信小程序读者端/week10-12（4.27开始）/project/book-mall/frontend/src/utils/regions.js'

data = [
    {"value": "110000", "label": "北京市", "children": [
        {"value": "110100", "label": "北京市", "children": [
            {"value": "110101", "label": "东城区"}, {"value": "110102", "label": "西城区"}, {"value": "110105", "label": "朝阳区"},
            {"value": "110106", "label": "丰台区"}, {"value": "110107", "label": "石景山区"}, {"value": "110108", "label": "海淀区"},
            {"value": "110109", "label": "门头沟区"}, {"value": "110111", "label": "房山区"}, {"value": "110112", "label": "通州区"},
            {"value": "110113", "label": "顺义区"}, {"value": "110114", "label": "昌平区"}, {"value": "110115", "label": "大兴区"},
            {"value": "110116", "label": "怀柔区"}, {"value": "110117", "label": "平谷区"}, {"value": "110118", "label": "密云区"},
            {"value": "110119", "label": "延庆区"}
        ]}
    ]},
    {"value": "120000", "label": "天津市", "children": [
        {"value": "120100", "label": "天津市", "children": [
            {"value": "120101", "label": "和平区"}, {"value": "120102", "label": "河东区"}, {"value": "120103", "label": "河西区"},
            {"value": "120104", "label": "南开区"}, {"value": "120105", "label": "河北区"}, {"value": "120106", "label": "红桥区"},
            {"value": "120110", "label": "东丽区"}, {"value": "120111", "label": "西青区"}, {"value": "120112", "label": "津南区"},
            {"value": "120113", "label": "北辰区"}, {"value": "120114", "label": "武清区"}, {"value": "120115", "label": "宝坻区"},
            {"value": "120116", "label": "滨海新区"}, {"value": "120117", "label": "宁河区"}, {"value": "120118", "label": "静海区"},
            {"value": "120119", "label": "蓟州区"}
        ]}
    ]},
    {"value": "130000", "label": "河北省", "children": [
        {"value": "130100", "label": "石家庄市", "children": [
            {"value": "130102", "label": "长安区"}, {"value": "130104", "label": "桥西区"}, {"value": "130105", "label": "新华区"},
            {"value": "130107", "label": "井陉矿区"}, {"value": "130108", "label": "裕华区"}, {"value": "130109", "label": "藁城区"},
            {"value": "130110", "label": "鹿泉区"}, {"value": "130111", "label": "栾城区"}, {"value": "130121", "label": "井陉县"},
            {"value": "130123", "label": "正定县"}, {"value": "130125", "label": "行唐县"}, {"value": "130126", "label": "灵寿县"},
            {"value": "130127", "label": "高邑县"}, {"value": "130128", "label": "深泽县"}, {"value": "130129", "label": "赞皇县"},
            {"value": "130130", "label": "无极县"}, {"value": "130131", "label": "平山县"}, {"value": "130132", "label": "元氏县"},
            {"value": "130133", "label": "赵县"}, {"value": "130185", "label": "晋州市"}, {"value": "130186", "label": "新乐市"}
        ]},
        {"value": "130200", "label": "唐山市", "children": [
            {"value": "130202", "label": "路南区"}, {"value": "130203", "label": "路北区"}, {"value": "130204", "label": "古冶区"},
            {"value": "130205", "label": "开平区"}, {"value": "130207", "label": "丰南区"}, {"value": "130208", "label": "丰润区"},
            {"value": "130209", "label": "曹妃甸区"}, {"value": "130224", "label": "滦南县"}, {"value": "130225", "label": "乐亭县"},
            {"value": "130227", "label": "迁西县"}, {"value": "130229", "label": "玉田县"}, {"value": "130281", "label": "遵化市"},
            {"value": "130283", "label": "迁安市"}
        ]},
        {"value": "130300", "label": "秦皇岛市", "children": [
            {"value": "130302", "label": "海港区"}, {"value": "130303", "label": "山海关区"}, {"value": "130304", "label": "北戴河区"},
            {"value": "130306", "label": "抚宁区"}, {"value": "130321", "label": "青龙满族自治县"}, {"value": "130322", "label": "昌黎县"},
            {"value": "130324", "label": "卢龙县"}
        ]},
        {"value": "130400", "label": "邯郸市", "children": [
            {"value": "130402", "label": "邯山区"}, {"value": "130403", "label": "丛台区"}, {"value": "130404", "label": "复兴区"},
            {"value": "130406", "label": "峰峰矿区"}, {"value": "130407", "label": "肥乡区"}, {"value": "130408", "label": "永年区"},
            {"value": "130423", "label": "临漳县"}, {"value": "130424", "label": "成安县"}, {"value": "130425", "label": "大名县"},
            {"value": "130426", "label": "涉县"}, {"value": "130427", "label": "磁县"}, {"value": "130430", "label": "邱县"},
            {"value": "130431", "label": "鸡泽县"}, {"value": "130432", "label": "广平县"}, {"value": "130433", "label": "馆陶县"},
            {"value": "130434", "label": "魏县"}, {"value": "130435", "label": "曲周县"}, {"value": "130481", "label": "武安市"}
        ]},
        {"value": "130500", "label": "邢台市", "children": [
            {"value": "130502", "label": "襄都区"}, {"value": "130503", "label": "信都区"}, {"value": "130505", "label": "任泽区"},
            {"value": "130506", "label": "南和区"}, {"value": "130522", "label": "临城县"}, {"value": "130523", "label": "内丘县"},
            {"value": "130524", "label": "柏乡县"}, {"value": "130525", "label": "隆尧县"}, {"value": "130528", "label": "宁晋县"},
            {"value": "130529", "label": "巨鹿县"}, {"value": "130530", "label": "新河县"}, {"value": "130531", "label": "广宗县"},
            {"value": "130532", "label": "平乡县"}, {"value": "130533", "label": "威县"}, {"value": "130534", "label": "清河县"},
            {"value": "130535", "label": "临西县"}, {"value": "130581", "label": "南宫市"}, {"value": "130582", "label": "沙河市"}
        ]},
        {"value": "130600", "label": "保定市", "children": [
            {"value": "130602", "label": "竞秀区"}, {"value": "130606", "label": "莲池区"}, {"value": "130607", "label": "满城区"},
            {"value": "130608", "label": "清苑区"}, {"value": "130609", "label": "徐水区"}, {"value": "130623", "label": "涞水县"},
            {"value": "130624", "label": "阜平县"}, {"value": "130626", "label": "定兴县"}, {"value": "130627", "label": "唐县"},
            {"value": "130628", "label": "高阳县"}, {"value": "130629", "label": "容城县"}, {"value": "130630", "label": "涞源县"},
            {"value": "130631", "label": "望都县"}, {"value": "130632", "label": "安新县"}, {"value": "130633", "label": "易县"},
            {"value": "130634", "label": "曲阳县"}, {"value": "130635", "label": "蠡县"}, {"value": "130636", "label": "顺平县"},
            {"value": "130637", "label": "博野县"}, {"value": "130638", "label": "雄县"}, {"value": "130681", "label": "涿州市"},
            {"value": "130682", "label": "定州市"}, {"value": "130683", "label": "安国市"}, {"value": "130684", "label": "高碑店市"}
        ]},
        {"value": "130700", "label": "张家口市", "children": [
            {"value": "130702", "label": "桥东区"}, {"value": "130703", "label": "桥西区"}, {"value": "130705", "label": "宣化区"},
            {"value": "130706", "label": "下花园区"}, {"value": "130708", "label": "万全区"}, {"value": "130709", "label": "崇礼区"},
            {"value": "130722", "label": "张北县"}, {"value": "130723", "label": "康保县"}, {"value": "130724", "label": "沽源县"},
            {"value": "130725", "label": "尚义县"}, {"value": "130726", "label": "蔚县"}, {"value": "130727", "label": "阳原县"},
            {"value": "130728", "label": "怀安县"}, {"value": "130730", "label": "怀来县"}, {"value": "130731", "label": "涿鹿县"},
            {"value": "130732", "label": "赤城县"}
        ]},
        {"value": "130800", "label": "承德市", "children": [
            {"value": "130802", "label": "双桥区"}, {"value": "130803", "label": "双滦区"}, {"value": "130804", "label": "鹰手营子矿区"},
            {"value": "130821", "label": "承德县"}, {"value": "130822", "label": "兴隆县"}, {"value": "130824", "label": "滦平县"},
            {"value": "130825", "label": "隆化县"}, {"value": "130826", "label": "丰宁满族自治县"}, {"value": "130827", "label": "宽城满族自治县"},
            {"value": "130828", "label": "围场满族蒙古族自治县"}, {"value": "130881", "label": "平泉市"}
        ]},
        {"value": "130900", "label": "沧州市", "children": [
            {"value": "130902", "label": "新华区"}, {"value": "130903", "label": "运河区"}, {"value": "130921", "label": "沧县"},
            {"value": "130922", "label": "青县"}, {"value": "130923", "label": "东光县"}, {"value": "130924", "label": "海兴县"},
            {"value": "130925", "label": "盐山县"}, {"value": "130926", "label": "肃宁县"}, {"value": "130927", "label": "南皮县"},
            {"value": "130928", "label": "吴桥县"}, {"value": "130929", "label": "献县"}, {"value": "130930", "label": "孟村回族自治县"},
            {"value": "130981", "label": "泊头市"}, {"value": "130982", "label": "任丘市"}, {"value": "130983", "label": "黄骅市"},
            {"value": "130984", "label": "河间市"}
        ]},
        {"value": "131000", "label": "廊坊市", "children": [
            {"value": "131002", "label": "安次区"}, {"value": "131003", "label": "广阳区"}, {"value": "131022", "label": "固安县"},
            {"value": "131023", "label": "永清县"}, {"value": "131024", "label": "香河县"}, {"value": "131025", "label": "大城县"},
            {"value": "131026", "label": "文安县"}, {"value": "131028", "label": "大厂回族自治县"}, {"value": "131081", "label": "霸州市"},
            {"value": "131082", "label": "三河市"}
        ]},
        {"value": "131100", "label": "衡水市", "children": [
            {"value": "131102", "label": "桃城区"}, {"value": "131103", "label": "冀州区"}, {"value": "131121", "label": "枣强县"},
            {"value": "131122", "label": "武邑县"}, {"value": "131123", "label": "武强县"}, {"value": "131124", "label": "饶阳县"},
            {"value": "131125", "label": "安平县"}, {"value": "131126", "label": "故城县"}, {"value": "131127", "label": "景县"},
            {"value": "131128", "label": "阜城县"}, {"value": "131182", "label": "深州市"}
        ]}
    ]},
    {"value": "140000", "label": "山西省", "children": [
        {"value": "140100", "label": "太原市", "children": [
            {"value": "140105", "label": "小店区"}, {"value": "140106", "label": "迎泽区"}, {"value": "140107", "label": "杏花岭区"},
            {"value": "140108", "label": "尖草坪区"}, {"value": "140109", "label": "万柏林区"}, {"value": "140110", "label": "晋源区"},
            {"value": "140121", "label": "清徐县"}, {"value": "140122", "label": "阳曲县"}, {"value": "140123", "label": "娄烦县"},
            {"value": "140181", "label": "古交市"}
        ]},
        {"value": "140200", "label": "大同市", "children": [
            {"value": "140212", "label": "新荣区"}, {"value": "140213", "label": "平城区"}, {"value": "140214", "label": "云冈区"},
            {"value": "140215", "label": "云州区"}, {"value": "140221", "label": "阳高县"}, {"value": "140222", "label": "天镇县"},
            {"value": "140223", "label": "广灵县"}, {"value": "140224", "label": "灵丘县"}, {"value": "140225", "label": "浑源县"},
            {"value": "140227", "label": "左云县"}
        ]},
        {"value": "140300", "label": "阳泉市", "children": [
            {"value": "140302", "label": "城区"}, {"value": "140303", "label": "矿区"}, {"value": "140311", "label": "郊区"},
            {"value": "140321", "label": "平定县"}, {"value": "140322", "label": "盂县"}
        ]},
        {"value": "140400", "label": "长治市", "children": [
            {"value": "140403", "label": "潞州区"}, {"value": "140404", "label": "上党区"}, {"value": "140405", "label": "屯留区"},
            {"value": "140406", "label": "潞城区"}, {"value": "140423", "label": "襄垣县"}, {"value": "140425", "label": "平顺县"},
            {"value": "140426", "label": "黎城县"}, {"value": "140427", "label": "壶关县"}, {"value": "140428", "label": "长子县"},
            {"value": "140429", "label": "武乡县"}, {"value": "140430", "label": "沁县"}, {"value": "140431", "label": "沁源县"}
        ]},
        {"value": "140500", "label": "晋城市", "children": [
            {"value": "140502", "label": "城区"}, {"value": "140521", "label": "沁水县"}, {"value": "140522", "label": "阳城县"},
            {"value": "140524", "label": "陵川县"}, {"value": "140525", "label": "泽州县"}, {"value": "140581", "label": "高平市"}
        ]},
        {"value": "140600", "label": "朔州市", "children": [
            {"value": "140602", "label": "朔城区"}, {"value": "140603", "label": "平鲁区"}, {"value": "140621", "label": "山阴县"},
            {"value": "140622", "label": "应县"}, {"value": "140623", "label": "右玉县"}, {"value": "140681", "label": "怀仁市"}
        ]},
        {"value": "140700", "label": "晋中市", "children": [
            {"value": "140702", "label": "榆次区"}, {"value": "140703", "label": "太谷区"}, {"value": "140721", "label": "榆社县"},
            {"value": "140722", "label": "左权县"}, {"value": "140723", "label": "和顺县"}, {"value": "140724", "label": "昔阳县"},
            {"value": "140725", "label": "寿阳县"}, {"value": "140727", "label": "祁县"}, {"value": "140728", "label": "平遥县"},
            {"value": "140729", "label": "灵石县"}, {"value": "140781", "label": "介休市"}
        ]},
        {"value": "140800", "label": "运城市", "children": [
            {"value": "140802", "label": "盐湖区"}, {"value": "140821", "label": "临猗县"}, {"value": "140822", "label": "万荣县"},
            {"value": "140823", "label": "闻喜县"}, {"value": "140824", "label": "稷山县"}, {"value": "140825", "label": "新绛县"},
            {"value": "140826", "label": "绛县"}, {"value": "140827", "label": "垣曲县"}, {"value": "140828", "label": "夏县"},
            {"value": "140829", "label": "平陆县"}, {"value": "140830", "label": "芮城县"}, {"value": "140881", "label": "永济市"},
            {"value": "140882", "label": "河津市"}
        ]},
        {"value": "140900", "label": "忻州市", "children": [
            {"value": "140902", "label": "忻府区"}, {"value": "140921", "label": "定襄县"}, {"value": "140922", "label": "五台县"},
            {"value": "140923", "label": "代县"}, {"value": "140924", "label": "繁峙县"}, {"value": "140925", "label": "宁武县"},
            {"value": "140926", "label": "静乐县"}, {"value": "140927", "label": "神池县"}, {"value": "140928", "label": "五寨县"},
            {"value": "140929", "label": "岢岚县"}, {"value": "140930", "label": "河曲县"}, {"value": "140931", "label": "保德县"},
            {"value": "140932", "label": "偏关县"}, {"value": "140981", "label": "原平市"}
        ]},
        {"value": "141000", "label": "临汾市", "children": [
            {"value": "141002", "label": "尧都区"}, {"value": "141021", "label": "曲沃县"}, {"value": "141022", "label": "翼城县"},
            {"value": "141023", "label": "襄汾县"}, {"value": "141024", "label": "洪洞县"}, {"value": "141025", "label": "古县"},
            {"value": "141026", "label": "安泽县"}, {"value": "141027", "label": "浮山县"}, {"value": "141028", "label": "吉县"},
            {"value": "141029", "label": "乡宁县"}, {"value": "141030", "label": "大宁县"}, {"value": "141031", "label": "隰县"},
            {"value": "141032", "label": "永和县"}, {"value": "141033", "label": "蒲县"}, {"value": "141034", "label": "汾西县"},
            {"value": "141081", "label": "侯马市"}, {"value": "141082", "label": "霍州市"}
        ]},
        {"value": "141100", "label": "吕梁市", "children": [
            {"value": "141102", "label": "离石区"}, {"value": "141121", "label": "文水县"}, {"value": "141122", "label": "交城县"},
            {"value": "141123", "label": "兴县"}, {"value": "141124", "label": "临县"}, {"value": "141125", "label": "柳林县"},
            {"value": "141126", "label": "石楼县"}, {"value": "141127", "label": "岚县"}, {"value": "141128", "label": "方山县"},
            {"value": "141129", "label": "中阳县"}, {"value": "141130", "label": "交口县"}, {"value": "141181", "label": "孝义市"},
            {"value": "141182", "label": "汾阳市"}
        ]}
    ]},
    {"value": "310000", "label": "上海市", "children": [
        {"value": "310100", "label": "上海市", "children": [
            {"value": "310101", "label": "黄浦区"}, {"value": "310104", "label": "徐汇区"}, {"value": "310105", "label": "长宁区"},
            {"value": "310106", "label": "静安区"}, {"value": "310107", "label": "普陀区"}, {"value": "310109", "label": "虹口区"},
            {"value": "310110", "label": "杨浦区"}, {"value": "310112", "label": "闵行区"}, {"value": "310113", "label": "宝山区"},
            {"value": "310114", "label": "嘉定区"}, {"value": "310115", "label": "浦东新区"}, {"value": "310116", "label": "金山区"},
            {"value": "310117", "label": "松江区"}, {"value": "310118", "label": "青浦区"}, {"value": "310120", "label": "奉贤区"},
            {"value": "310151", "label": "崇明区"}
        ]}
    ]},
    {"value": "320000", "label": "江苏省", "children": [
        {"value": "320100", "label": "南京市", "children": [
            {"value": "320102", "label": "玄武区"}, {"value": "320104", "label": "秦淮区"}, {"value": "320105", "label": "建邺区"},
            {"value": "320106", "label": "鼓楼区"}, {"value": "320111", "label": "浦口区"}, {"value": "320113", "label": "栖霞区"},
            {"value": "320114", "label": "雨花台区"}, {"value": "320115", "label": "江宁区"}, {"value": "320116", "label": "六合区"},
            {"value": "320117", "label": "溧水区"}, {"value": "320118", "label": "高淳区"}
        ]},
        {"value": "320200", "label": "无锡市", "children": [
            {"value": "320205", "label": "锡山区"}, {"value": "320206", "label": "惠山区"}, {"value": "320211", "label": "滨湖区"},
            {"value": "320213", "label": "梁溪区"}, {"value": "320214", "label": "新吴区"}, {"value": "320281", "label": "江阴市"},
            {"value": "320282", "label": "宜兴市"}
        ]},
        {"value": "320300", "label": "徐州市", "children": [
            {"value": "320302", "label": "鼓楼区"}, {"value": "320303", "label": "云龙区"}, {"value": "320305", "label": "贾汪区"},
            {"value": "320311", "label": "泉山区"}, {"value": "320312", "label": "铜山区"}, {"value": "320321", "label": "丰县"},
            {"value": "320322", "label": "沛县"}, {"value": "320324", "label": "睢宁县"}, {"value": "320381", "label": "新沂市"},
            {"value": "320382", "label": "邳州市"}
        ]},
        {"value": "320400", "label": "常州市", "children": [
            {"value": "320402", "label": "天宁区"}, {"value": "320404", "label": "钟楼区"}, {"value": "320411", "label": "新北区"},
            {"value": "320412", "label": "武进区"}, {"value": "320413", "label": "金坛区"}, {"value": "320481", "label": "溧阳市"}
        ]},
        {"value": "320500", "label": "苏州市", "children": [
            {"value": "320505", "label": "虎丘区"}, {"value": "320506", "label": "吴中区"}, {"value": "320507", "label": "相城区"},
            {"value": "320508", "label": "姑苏区"}, {"value": "320509", "label": "吴江区"}, {"value": "320512", "label": "苏州工业园区"},
            {"value": "320581", "label": "常熟市"}, {"value": "320582", "label": "张家港市"}, {"value": "320583", "label": "昆山市"},
            {"value": "320585", "label": "太仓市"}
        ]},
        {"value": "320600", "label": "南通市", "children": [
            {"value": "320602", "label": "崇川区"}, {"value": "320611", "label": "通州区"}, {"value": "320612", "label": "如东县"},
            {"value": "320681", "label": "启东市"}, {"value": "320682", "label": "如皋市"}, {"value": "320684", "label": "海门市"},
            {"value": "320685", "label": "海安市"}
        ]},
        {"value": "320700", "label": "连云港市", "children": [
            {"value": "320703", "label": "连云区"}, {"value": "320706", "label": "海州区"}, {"value": "320707", "label": "赣榆区"},
            {"value": "320722", "label": "东海县"}, {"value": "320723", "label": "灌云县"}, {"value": "320724", "label": "灌南县"}
        ]},
        {"value": "320800", "label": "淮安市", "children": [
            {"value": "320803", "label": "淮安区"}, {"value": "320804", "label": "淮阴区"}, {"value": "320812", "label": "清江浦区"},
            {"value": "320813", "label": "洪泽区"}, {"value": "320826", "label": "涟水县"}, {"value": "320830", "label": "盱眙县"},
            {"value": "320831", "label": "金湖县"}
        ]},
        {"value": "320900", "label": "盐城市", "children": [
            {"value": "320902", "label": "亭湖区"}, {"value": "320903", "label": "盐都区"}, {"value": "320904", "label": "大丰区"},
            {"value": "320921", "label": "响水县"}, {"value": "320922", "label": "滨海县"}, {"value": "320923", "label": "阜宁县"},
            {"value": "320924", "label": "射阳县"}, {"value": "320925", "label": "建湖县"}, {"value": "320981", "label": "东台市"}
        ]},
        {"value": "321000", "label": "扬州市", "children": [
            {"value": "321002", "label": "广陵区"}, {"value": "321003", "label": "邗江区"}, {"value": "321012", "label": "江都区"},
            {"value": "321023", "label": "宝应县"}, {"value": "321081", "label": "仪征市"}, {"value": "321084", "label": "高邮市"}
        ]},
        {"value": "321100", "label": "镇江市", "children": [
            {"value": "321102", "label": "京口区"}, {"value": "321111", "label": "润州区"}, {"value": "321112", "label": "丹徒区"},
            {"value": "321181", "label": "丹阳市"}, {"value": "321182", "label": "扬中市"}, {"value": "321183", "label": "句容市"}
        ]},
        {"value": "321200", "label": "泰州市", "children": [
            {"value": "321202", "label": "海陵区"}, {"value": "321203", "label": "高港区"}, {"value": "321204", "label": "姜堰区"},
            {"value": "321281", "label": "兴化市"}, {"value": "321282", "label": "靖江市"}, {"value": "321283", "label": "泰兴市"}
        ]},
        {"value": "321300", "label": "宿迁市", "children": [
            {"value": "321302", "label": "宿城区"}, {"value": "321311", "label": "宿豫区"}, {"value": "321322", "label": "沭阳县"},
            {"value": "321323", "label": "泗阳县"}, {"value": "321324", "label": "泗洪县"}
        ]}
    ]},
    {"value": "330000", "label": "浙江省", "children": [
        {"value": "330100", "label": "杭州市", "children": [
            {"value": "330102", "label": "上城区"}, {"value": "330105", "label": "拱墅区"}, {"value": "330106", "label": "西湖区"},
            {"value": "330108", "label": "滨江区"}, {"value": "330109", "label": "萧山区"}, {"value": "330110", "label": "余杭区"},
            {"value": "330111", "label": "富阳区"}, {"value": "330112", "label": "临安区"}, {"value": "330122", "label": "桐庐县"},
            {"value": "330127", "label": "淳安县"}, {"value": "330182", "label": "建德市"}
        ]},
        {"value": "330200", "label": "宁波市", "children": [
            {"value": "330203", "label": "海曙区"}, {"value": "330205", "label": "江北区"}, {"value": "330206", "label": "北仑区"},
            {"value": "330211", "label": "镇海区"}, {"value": "330212", "label": "鄞州区"}, {"value": "330213", "label": "奉化区"},
            {"value": "330225", "label": "象山县"}, {"value": "330226", "label": "宁海县"}, {"value": "330281", "label": "余姚市"},
            {"value": "330282", "label": "慈溪市"}
        ]},
        {"value": "330300", "label": "温州市", "children": [
            {"value": "330302", "label": "鹿城区"}, {"value": "330303", "label": "龙湾区"}, {"value": "330304", "label": "瓯海区"},
            {"value": "330305", "label": "洞头区"}, {"value": "330324", "label": "永嘉县"}, {"value": "330326", "label": "平阳县"},
            {"value": "330327", "label": "苍南县"}, {"value": "330328", "label": "文成县"}, {"value": "330329", "label": "泰顺县"},
            {"value": "330381", "label": "瑞安市"}, {"value": "330382", "label": "乐清市"}
        ]},
        {"value": "330400", "label": "嘉兴市", "children": [
            {"value": "330402", "label": "南湖区"}, {"value": "330411", "label": "秀洲区"}, {"value": "330421", "label": "嘉善县"},
            {"value": "330424", "label": "海盐县"}, {"value": "330481", "label": "海宁市"}, {"value": "330482", "label": "平湖市"},
            {"value": "330483", "label": "桐乡市"}
        ]},
        {"value": "330500", "label": "湖州市", "children": [
            {"value": "330502", "label": "吴兴区"}, {"value": "330503", "label": "南浔区"}, {"value": "330521", "label": "德清县"},
            {"value": "330522", "label": "长兴县"}, {"value": "330523", "label": "安吉县"}
        ]},
        {"value": "330600", "label": "绍兴市", "children": [
            {"value": "330602", "label": "越城区"}, {"value": "330603", "label": "柯桥区"}, {"value": "330604", "label": "上虞区"},
            {"value": "330624", "label": "新昌县"}, {"value": "330681", "label": "诸暨市"}, {"value": "330683", "label": "嵊州市"}
        ]},
        {"value": "330700", "label": "金华市", "children": [
            {"value": "330702", "label": "婺城区"}, {"value": "330703", "label": "金东区"}, {"value": "330723", "label": "武义县"},
            {"value": "330726", "label": "浦江县"}, {"value": "330727", "label": "磐安县"}, {"value": "330781", "label": "兰溪市"},
            {"value": "330782", "label": "义乌市"}, {"value": "330783", "label": "东阳市"}, {"value": "330784", "label": "永康市"}
        ]},
        {"value": "330800", "label": "衢州市", "children": [
            {"value": "330802", "label": "柯城区"}, {"value": "330803", "label": "衢江区"}, {"value": "330822", "label": "常山县"},
            {"value": "330824", "label": "开化县"}, {"value": "330825", "label": "龙游县"}, {"value": "330881", "label": "江山市"}
        ]},
        {"value": "330900", "label": "舟山市", "children": [
            {"value": "330902", "label": "定海区"}, {"value": "330903", "label": "普陀区"}, {"value": "330921", "label": "岱山县"},
            {"value": "330922", "label": "嵊泗县"}
        ]},
        {"value": "331000", "label": "台州市", "children": [
            {"value": "331002", "label": "椒江区"}, {"value": "331003", "label": "黄岩区"}, {"value": "331004", "label": "路桥区"},
            {"value": "331022", "label": "三门县"}, {"value": "331023", "label": "天台县"}, {"value": "331024", "label": "仙居县"},
            {"value": "331081", "label": "温岭市"}, {"value": "331082", "label": "临海市"}, {"value": "331083", "label": "玉环市"}
        ]},
        {"value": "331100", "label": "丽水市", "children": [
            {"value": "331102", "label": "莲都区"}, {"value": "331121", "label": "青田县"}, {"value": "331122", "label": "缙云县"},
            {"value": "331123", "label": "遂昌县"}, {"value": "331124", "label": "松阳县"}, {"value": "331125", "label": "云和县"},
            {"value": "331126", "label": "庆元县"}, {"value": "331127", "label": "景宁畲族自治县"}, {"value": "331181", "label": "龙泉市"}
        ]}
    ]}
]

with open(output_path, 'w', encoding='utf-8') as f:
    f.write('export default ')
    json.dump(data, f, ensure_ascii=False, indent=2)
    f.write(';\n')

print("regions.js updated successfully!")
