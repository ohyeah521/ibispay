//
//  GlobalDefine.m
//  Ibis
//
//  Created by 鸟神 on 2017/6/12.
//  Copyright © 2017年 xingdongpai.com. All rights reserved.
//

#import "GlobalDefine.h"
#import "XLForm.h"

@implementation GlobalDefine
    
+ (NSArray *)CCArray{
    return @[
             [XLFormOptionsObject formOptionsObjectWithValue:@"中国 (CN)" displayText:@"中国 (CN)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"香港 (HK)" displayText:@"香港 (HK)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"台湾 (TW)" displayText:@"台湾 (TW)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"澳门 (MO)" displayText:@"澳门 (MO)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"美国 (US)" displayText:@"美国 (US)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"英国 (GB)" displayText:@"英国 (GB)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"新加坡 (SG)" displayText:@"新加坡 (SG)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"日本 (JP)" displayText:@"日本 (JP)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"巴西 (BR)" displayText:@"巴西 (BR)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"德国 (DE)" displayText:@"德国 (DE)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"法国 (FR)" displayText:@"法国 (FR)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"泰国 (TH)" displayText:@"泰国 (TH)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"希腊 (GR)" displayText:@"希腊 (GR)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"西班牙 (ES)" displayText:@"西班牙 (ES)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"意大利 (IT)" displayText:@"意大利 (IT)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"印度 (IN)" displayText:@"印度 (IN)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"英属维京群岛 (VG)" displayText:@"英属维京群岛 (VG)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"英属印度洋领地 (IO)" displayText:@"英属印度洋领地 (IO)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"美国本土外小岛屿 (UM)" displayText:@"美国本土外小岛屿 (UM)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"美属萨摩亚 (AS)" displayText:@"美属萨摩亚 (AS)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"美属维京群岛 (VI)" displayText:@"美属维京群岛 (VI)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"阿尔巴尼亚 (AL)" displayText:@"阿尔巴尼亚 (AL)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"阿尔及利亚 (DZ)" displayText:@"阿尔及利亚 (DZ)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"阿富汗 (AF)" displayText:@"阿富汗 (AF)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"阿根廷 (AR)" displayText:@"阿根廷 (AR)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"阿拉伯联合酋长国 (AE)" displayText:@"阿拉伯联合酋长国 (AE)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"阿鲁巴 (AW)" displayText:@"阿鲁巴 (AW)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"阿曼 (OM)" displayText:@"阿曼 (OM)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"阿塞拜疆 (AZ)" displayText:@"阿塞拜疆 (AZ)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"阿森松岛 (AC)" displayText:@"阿森松岛 (AC)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"埃及 (EG)" displayText:@"埃及 (EG)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"埃塞俄比亚 (ET)" displayText:@"埃塞俄比亚 (ET)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"爱尔兰 (IE)" displayText:@"爱尔兰 (IE)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"爱沙尼亚 (EE)" displayText:@"爱沙尼亚 (EE)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"安道尔 (AD)" displayText:@"安道尔 (AD)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"安哥拉 (AO)" displayText:@"安哥拉 (AO)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"安圭拉 (AI)" displayText:@"安圭拉 (AI)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"安提瓜和巴布达 (AG)" displayText:@"安提瓜和巴布达 (AG)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"奥地利 (AT)" displayText:@"奥地利 (AT)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"奥兰群岛 (AX)" displayText:@"奥兰群岛 (AX)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"澳大利亚 (AU)" displayText:@"澳大利亚 (AU)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"巴巴多斯 (BB)" displayText:@"巴巴多斯 (BB)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"巴布亚新几内亚 (PG)" displayText:@"巴布亚新几内亚 (PG)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"巴哈马 (BS)" displayText:@"巴哈马 (BS)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"巴基斯坦 (PK)" displayText:@"巴基斯坦 (PK)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"巴拉圭 (PY)" displayText:@"巴拉圭 (PY)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"巴勒斯坦领土 (PS)" displayText:@"巴勒斯坦领土 (PS)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"巴林 (BH)" displayText:@"巴林 (BH)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"巴拿马 (PA)" displayText:@"巴拿马 (PA)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"白俄罗斯 (BY)" displayText:@"白俄罗斯 (BY)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"百慕大 (BM)" displayText:@"百慕大 (BM)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"保加利亚 (BG)" displayText:@"保加利亚 (BG)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"北马里亚纳群岛 (MP)" displayText:@"北马里亚纳群岛 (MP)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"贝宁 (BJ)" displayText:@"贝宁 (BJ)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"比利时 (BE)" displayText:@"比利时 (BE)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"冰岛 (IS)" displayText:@"冰岛 (IS)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"波多黎各 (PR)" displayText:@"波多黎各 (PR)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"波兰 (PL)" displayText:@"波兰 (PL)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"波斯尼亚和黑塞哥维那 (BA)" displayText:@"波斯尼亚和黑塞哥维那 (BA)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"玻利维亚 (BO)" displayText:@"玻利维亚 (BO)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"伯利兹 (BZ)" displayText:@"伯利兹 (BZ)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"博茨瓦纳 (BW)" displayText:@"博茨瓦纳 (BW)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"不丹 (BT)" displayText:@"不丹 (BT)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"布基纳法索 (BF)" displayText:@"布基纳法索 (BF)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"布隆迪 (BI)" displayText:@"布隆迪 (BI)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"朝鲜 (KP)" displayText:@"朝鲜 (KP)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"赤道几内亚 (GQ)" displayText:@"赤道几内亚 (GQ)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"丹麦 (DK)" displayText:@"丹麦 (DK)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"迪戈加西亚岛 (DG)" displayText:@"迪戈加西亚岛 (DG)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"东帝汶 (TL)" displayText:@"东帝汶 (TL)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"多哥 (TG)" displayText:@"多哥 (TG)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"多米尼加共和国 (DO)" displayText:@"多米尼加共和国 (DO)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"多米尼克 (DM)" displayText:@"多米尼克 (DM)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"俄罗斯 (RU)" displayText:@"俄罗斯 (RU)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"厄瓜多尔 (EC)" displayText:@"厄瓜多尔 (EC)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"厄立特里亚 (ER)" displayText:@"厄立特里亚 (ER)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"法罗群岛 (FO)" displayText:@"法罗群岛 (FO)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"法属波利尼西亚 (PF)" displayText:@"法属波利尼西亚 (PF)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"法属圭亚那 (GF)" displayText:@"法属圭亚那 (GF)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"法属南部领地 (TF)" displayText:@"法属南部领地 (TF)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"法属圣马丁 (MF)" displayText:@"法属圣马丁 (MF)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"梵蒂冈 (VA)" displayText:@"梵蒂冈 (VA)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"菲律宾 (PH)" displayText:@"菲律宾 (PH)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"斐济 (FJ)" displayText:@"斐济 (FJ)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"芬兰 (FI)" displayText:@"芬兰 (FI)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"佛得角 (CV)" displayText:@"佛得角 (CV)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"福克兰群岛 (FK)" displayText:@"福克兰群岛 (FK)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"冈比亚 (GM)" displayText:@"冈比亚 (GM)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"刚果（布） (CG)" displayText:@"刚果（布） (CG)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"刚果（金） (CD)" displayText:@"刚果（金） (CD)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"哥伦比亚 (CO)" displayText:@"哥伦比亚 (CO)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"哥斯达黎加 (CR)" displayText:@"哥斯达黎加 (CR)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"格林纳达 (GD)" displayText:@"格林纳达 (GD)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"格陵兰 (GL)" displayText:@"格陵兰 (GL)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"格鲁吉亚 (GE)" displayText:@"格鲁吉亚 (GE)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"根西岛 (GG)" displayText:@"根西岛 (GG)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"古巴 (CU)" displayText:@"古巴 (CU)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"瓜德罗普 (GP)" displayText:@"瓜德罗普 (GP)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"关岛 (GU)" displayText:@"关岛 (GU)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"圭亚那 (GY)" displayText:@"圭亚那 (GY)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"哈萨克斯坦 (KZ)" displayText:@"哈萨克斯坦 (KZ)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"海地 (HT)" displayText:@"海地 (HT)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"韩国 (KR)" displayText:@"韩国 (KR)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"荷兰 (NL)" displayText:@"荷兰 (NL)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"荷兰加勒比区 (BQ)" displayText:@"荷兰加勒比区 (BQ)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"荷属圣马丁 (SX)" displayText:@"荷属圣马丁 (SX)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"黑山共和国 (ME)" displayText:@"黑山共和国 (ME)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"洪都拉斯 (HN)" displayText:@"洪都拉斯 (HN)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"基里巴斯 (KI)" displayText:@"基里巴斯 (KI)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"吉布提 (DJ)" displayText:@"吉布提 (DJ)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"吉尔吉斯斯坦 (KG)" displayText:@"吉尔吉斯斯坦 (KG)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"几内亚 (GN)" displayText:@"几内亚 (GN)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"几内亚比绍 (GW)" displayText:@"几内亚比绍 (GW)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"加拿大 (CA)" displayText:@"加拿大 (CA)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"加纳 (GH)" displayText:@"加纳 (GH)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"加纳利群岛 (IC)" displayText:@"加纳利群岛 (IC)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"加蓬 (GA)" displayText:@"加蓬 (GA)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"柬埔寨 (KH)" displayText:@"柬埔寨 (KH)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"捷克共和国 (CZ)" displayText:@"捷克共和国 (CZ)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"津巴布韦 (ZW)" displayText:@"津巴布韦 (ZW)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"喀麦隆 (CM)" displayText:@"喀麦隆 (CM)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"卡塔尔 (QA)" displayText:@"卡塔尔 (QA)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"开曼群岛 (KY)" displayText:@"开曼群岛 (KY)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"科科斯（基林）群岛 (CC)" displayText:@"科科斯（基林）群岛 (CC)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"科摩罗 (KM)" displayText:@"科摩罗 (KM)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"科索沃 (XK)" displayText:@"科索沃 (XK)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"科特迪瓦 (CI)" displayText:@"科特迪瓦 (CI)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"科威特 (KW)" displayText:@"科威特 (KW)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"克罗地亚 (HR)" displayText:@"克罗地亚 (HR)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"肯尼亚 (KE)" displayText:@"肯尼亚 (KE)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"库克群岛 (CK)" displayText:@"库克群岛 (CK)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"库拉索 (CW)" displayText:@"库拉索 (CW)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"拉脱维亚 (LV)" displayText:@"拉脱维亚 (LV)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"莱索托 (LS)" displayText:@"莱索托 (LS)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"老挝 (LA)" displayText:@"老挝 (LA)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"黎巴嫩 (LB)" displayText:@"黎巴嫩 (LB)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"立陶宛 (LT)" displayText:@"立陶宛 (LT)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"利比里亚 (LR)" displayText:@"利比里亚 (LR)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"利比亚 (LY)" displayText:@"利比亚 (LY)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"列支敦士登 (LI)" displayText:@"列支敦士登 (LI)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"留尼汪 (RE)" displayText:@"留尼汪 (RE)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"卢森堡 (LU)" displayText:@"卢森堡 (LU)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"卢旺达 (RW)" displayText:@"卢旺达 (RW)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"罗马尼亚 (RO)" displayText:@"罗马尼亚 (RO)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"马达加斯加 (MG)" displayText:@"马达加斯加 (MG)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"马尔代夫 (MV)" displayText:@"马尔代夫 (MV)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"马耳他 (MT)" displayText:@"马耳他 (MT)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"马拉维 (MW)" displayText:@"马拉维 (MW)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"马来西亚 (MY)" displayText:@"马来西亚 (MY)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"马里 (ML)" displayText:@"马里 (ML)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"马其顿 (MK)" displayText:@"马其顿 (MK)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"马绍尔群岛 (MH)" displayText:@"马绍尔群岛 (MH)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"马提尼克 (MQ)" displayText:@"马提尼克 (MQ)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"马约特 (YT)" displayText:@"马约特 (YT)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"曼岛 (IM)" displayText:@"曼岛 (IM)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"毛里求斯 (MU)" displayText:@"毛里求斯 (MU)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"毛里塔尼亚 (MR)" displayText:@"毛里塔尼亚 (MR)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"蒙古 (MN)" displayText:@"蒙古 (MN)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"蒙特塞拉特 (MS)" displayText:@"蒙特塞拉特 (MS)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"孟加拉国 (BD)" displayText:@"孟加拉国 (BD)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"秘鲁 (PE)" displayText:@"秘鲁 (PE)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"密克罗尼西亚 (FM)" displayText:@"密克罗尼西亚 (FM)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"缅甸 (MM)" displayText:@"缅甸 (MM)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"摩尔多瓦 (MD)" displayText:@"摩尔多瓦 (MD)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"摩洛哥 (MA)" displayText:@"摩洛哥 (MA)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"摩纳哥 (MC)" displayText:@"摩纳哥 (MC)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"莫桑比克 (MZ)" displayText:@"莫桑比克 (MZ)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"墨西哥 (MX)" displayText:@"墨西哥 (MX)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"纳米比亚 (NA)" displayText:@"纳米比亚 (NA)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"南非 (ZA)" displayText:@"南非 (ZA)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"南极洲 (AQ)" displayText:@"南极洲 (AQ)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"南乔治亚岛和南桑威齐群岛 (GS)" displayText:@"南乔治亚岛和南桑威齐群岛 (GS)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"南苏丹 (SS)" displayText:@"南苏丹 (SS)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"瑙鲁 (NR)" displayText:@"瑙鲁 (NR)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"尼加拉瓜 (NI)" displayText:@"尼加拉瓜 (NI)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"尼泊尔 (NP)" displayText:@"尼泊尔 (NP)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"尼日尔 (NE)" displayText:@"尼日尔 (NE)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"尼日利亚 (NG)" displayText:@"尼日利亚 (NG)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"纽埃 (NU)" displayText:@"纽埃 (NU)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"挪威 (NO)" displayText:@"挪威 (NO)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"诺福克岛 (NF)" displayText:@"诺福克岛 (NF)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"帕劳 (PW)" displayText:@"帕劳 (PW)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"皮特凯恩群岛 (PN)" displayText:@"皮特凯恩群岛 (PN)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"葡萄牙 (PT)" displayText:@"葡萄牙 (PT)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"瑞典 (SE)" displayText:@"瑞典 (SE)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"瑞士 (CH)" displayText:@"瑞士 (CH)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"萨尔瓦多 (SV)" displayText:@"萨尔瓦多 (SV)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"萨摩亚 (WS)" displayText:@"萨摩亚 (WS)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"塞尔维亚 (RS)" displayText:@"塞尔维亚 (RS)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"塞拉利昂 (SL)" displayText:@"塞拉利昂 (SL)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"塞内加尔 (SN)" displayText:@"塞内加尔 (SN)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"塞浦路斯 (CY)" displayText:@"塞浦路斯 (CY)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"塞舌尔 (SC)" displayText:@"塞舌尔 (SC)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"沙特阿拉伯 (SA)" displayText:@"沙特阿拉伯 (SA)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"圣巴泰勒米 (BL)" displayText:@"圣巴泰勒米 (BL)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"圣诞岛 (CX)" displayText:@"圣诞岛 (CX)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"圣多美和普林西比 (ST)" displayText:@"圣多美和普林西比 (ST)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"圣赫勒拿 (SH)" displayText:@"圣赫勒拿 (SH)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"圣基茨和尼维斯 (KN)" displayText:@"圣基茨和尼维斯 (KN)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"圣卢西亚 (LC)" displayText:@"圣卢西亚 (LC)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"圣马力诺 (SM)" displayText:@"圣马力诺 (SM)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"圣皮埃尔和密克隆群岛 (PM)" displayText:@"圣皮埃尔和密克隆群岛 (PM)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"圣文森特和格林纳丁斯 (VC)" displayText:@"圣文森特和格林纳丁斯 (VC)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"斯里兰卡 (LK)" displayText:@"斯里兰卡 (LK)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"斯洛伐克 (SK)" displayText:@"斯洛伐克 (SK)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"斯洛文尼亚 (SI)" displayText:@"斯洛文尼亚 (SI)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"斯瓦尔巴特和扬马延 (SJ)" displayText:@"斯瓦尔巴特和扬马延 (SJ)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"斯威士兰 (SZ)" displayText:@"斯威士兰 (SZ)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"苏丹 (SD)" displayText:@"苏丹 (SD)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"苏里南 (SR)" displayText:@"苏里南 (SR)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"所罗门群岛 (SB)" displayText:@"所罗门群岛 (SB)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"索马里 (SO)" displayText:@"索马里 (SO)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"塔吉克斯坦 (TJ)" displayText:@"塔吉克斯坦 (TJ)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"坦桑尼亚 (TZ)" displayText:@"坦桑尼亚 (TZ)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"汤加 (TO)" displayText:@"汤加 (TO)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"特克斯和凯科斯群岛 (TC)" displayText:@"特克斯和凯科斯群岛 (TC)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"特里斯坦-达库尼亚群岛 (TA)" displayText:@"特里斯坦-达库尼亚群岛 (TA)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"特立尼达和多巴哥 (TT)" displayText:@"特立尼达和多巴哥 (TT)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"突尼斯 (TN)" displayText:@"突尼斯 (TN)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"图瓦卢 (TV)" displayText:@"图瓦卢 (TV)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"土耳其 (TR)" displayText:@"土耳其 (TR)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"土库曼斯坦 (TM)" displayText:@"土库曼斯坦 (TM)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"托克劳 (TK)" displayText:@"托克劳 (TK)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"瓦利斯和富图纳 (WF)" displayText:@"瓦利斯和富图纳 (WF)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"瓦努阿图 (VU)" displayText:@"瓦努阿图 (VU)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"危地马拉 (GT)" displayText:@"危地马拉 (GT)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"委内瑞拉 (VE)" displayText:@"委内瑞拉 (VE)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"文莱 (BN)" displayText:@"文莱 (BN)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"乌干达 (UG)" displayText:@"乌干达 (UG)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"乌克兰 (UA)" displayText:@"乌克兰 (UA)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"乌拉圭 (UY)" displayText:@"乌拉圭 (UY)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"乌兹别克斯坦 (UZ)" displayText:@"乌兹别克斯坦 (UZ)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"西撒哈拉 (EH)" displayText:@"西撒哈拉 (EH)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"新喀里多尼亚 (NC)" displayText:@"新喀里多尼亚 (NC)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"新西兰 (NZ)" displayText:@"新西兰 (NZ)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"匈牙利 (HU)" displayText:@"匈牙利 (HU)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"休达及梅利利亚 (EA)" displayText:@"休达及梅利利亚 (EA)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"叙利亚 (SY)" displayText:@"叙利亚 (SY)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"牙买加 (JM)" displayText:@"牙买加 (JM)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"亚美尼亚 (AM)" displayText:@"亚美尼亚 (AM)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"也门 (YE)" displayText:@"也门 (YE)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"伊拉克 (IQ)" displayText:@"伊拉克 (IQ)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"伊朗 (IR)" displayText:@"伊朗 (IR)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"以色列 (IL)" displayText:@"以色列 (IL)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"印度尼西亚 (ID)" displayText:@"印度尼西亚 (ID)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"约旦 (JO)" displayText:@"约旦 (JO)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"越南 (VN)" displayText:@"越南 (VN)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"赞比亚 (ZM)" displayText:@"赞比亚 (ZM)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"泽西岛 (JE)" displayText:@"泽西岛 (JE)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"乍得 (TD)" displayText:@"乍得 (TD)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"直布罗陀 (GI)" displayText:@"直布罗陀 (GI)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"智利 (CL)" displayText:@"智利 (CL)"],
             [XLFormOptionsObject formOptionsObjectWithValue:@"中非共和国 (CF)" displayText:@"中非共和国 (CF)"],
             ];
}
    
    
@end
