//
//  CSPopDescModel.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/9.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSPopDescModel.h"

@implementation CSPopDescModel

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        CGFloat contentW = SCREENWIDTH * 0.7;
        CGFloat contentH = [self.rowTitle boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.]} context:nil].size.height;
        _cellHeight = contentH + 20;
    }
    return _cellHeight;
}

- (CGFloat)sectionHeight {
    if (!_sectionHeight) {
        CGFloat contentW = SCREENWIDTH * 0.7;
        CGFloat contentH = [self.sectionTitle boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.]} context:nil].size.height;
        _sectionHeight = contentH + 20;
    }
    return _sectionHeight;
}

+ (NSArray *)getCouponSectionDescData {
    NSArray *sectionArr = @[@{@"sectionTitle":@"1.如何查看我的优惠卷？"},@{@"sectionTitle":@"2.目前平台有哪些种类的优惠卷？"},@{@"sectionTitle":@"3.如何判断是否满足优惠卷的使用条件？"},@{@"sectionTitle":@"4.优惠卷可以叠加使用吗？"},@{@"sectionTitle":@"5.使用优惠卷下单后，若申请售后，优惠卷退还给用户吗？"}];
    return sectionArr;
}
+ (NSArray *)getCouponRowDescData {
    NSArray *rowArr = @[@[@{@"rowTitle":@"在APP，点击底部导航栏[店铺]中优惠卷进行查询；"}],@[@{@"rowTitle":@"目前平台有满减卷，即满一定额度门槛可享受使用优惠卷；目前满减卷的优惠额度是满一百减五十，即使用优惠卷的门槛是100元，单笔订单只可使用一张优惠卷。"}],@[@{@"rowTitle":@"a优惠卷是有有效期的，使用日期需在有效期范围内；"},@{@"rowTitle":@"b订单的商品金额(是指商品金额，不包含运费、税费)必须满足优惠卷的使用门槛。"}],@[@{@"rowTitle":@"一个订单达到使用门槛只可使用一张优惠卷，不可叠加使用。"}],@[@{@"rowTitle":@"使用优惠卷下单购买商品后，申请售后进行退款退货时，优惠卷也会退还给用户帐号上。"}]];
    return rowArr;
}

+ (NSArray *)getRegistSectionDescData {
    NSArray *sectionArr = @[@{@"sectionTitle":@"提示条款："},
                            @{@"sectionTitle":@"一、协议范围 \n\n 1.1 签约主体"},
                            @{@"sectionTitle":@"1.2 补充协议"},
                            @{@"sectionTitle":@"二、账户开通与使用 \n\n 2.1 用户资格"},
                            @{@"sectionTitle":@"2.2 账户登录与激活"},
                            @{@"sectionTitle":@"2.3 账户转让"},
                            @{@"sectionTitle":@"2.4 信息管理"},
                            @{@"sectionTitle":@"2.5 店铺名称"},
                            @{@"sectionTitle":@"2.6 账户安全管理"},
                            @{@"sectionTitle":@"2.7 日常维护须知"},
                            @{@"sectionTitle":@"三、你的铺子服务及规范 \n\n 3.1 服务概况"},
                            @{@"sectionTitle":@"3.2 推广权限"},
                            @{@"sectionTitle":@"3.3 服务费用"},
                            @{@"sectionTitle":@"3.4 推广费用"},
                            @{@"sectionTitle":@"3.5 税费及其他费用"},
                            @{@"sectionTitle":@"四、用户信息的保护及授权 \n\n 4.1 个人信息的保护"},
                            @{@"sectionTitle":@"4.2 信息的发布"},
                            @{@"sectionTitle":@"4.3 禁止性信息"},
                            @{@"sectionTitle":@"4.4 授权使用"},
                            @{@"sectionTitle":@"五、用户的违约及处理 \n\n 5.1 违约认定"},
                            @{@"sectionTitle":@"5.2 违约处理措施"},
                            @{@"sectionTitle":@"5.3 赔偿责任"},
                            @{@"sectionTitle":@"六、协议的变更"},
                            @{@"sectionTitle":@"七、通知"},
                            @{@"sectionTitle":@"八、协议的终止 \n\n 8.1 您有权通过以下任一方式终止本协议:"},
                            @{@"sectionTitle":@"8.2 出现以下情况的，你的铺子可以本协议约定方式通知您终止本协议："},
                            @{@"sectionTitle":@"8.3 本协议终止后，你的铺子仍享有下列权利："},
                            @{@"sectionTitle":@"九、法律适用、管辖与其他"},
                            
                            ];
    return sectionArr;
}
+ (NSArray *)getRegistRowDescData {
    NSArray *rowArr = @[
                        @[@{@"rowTitle":@"【审慎阅读】您在点击确认本协议或使用你的铺子服务之前，应当认真阅读本协议。请您务必审慎阅读、充分理解各条款内容，特别是免除或限制责任、法律适用和争议解决等以粗体下划线格式特别标识的条款，您应重点阅读。如您对本协议有任何疑问，可向你的铺子客服咨询。"},
                          @{@"rowTitle":@"【签约使用】当您点击确认本协议或使用你的铺子服务时，即表示您已充分阅读、理解并接受本协议的全部内容，并与你的铺子达成一致。本协议自您点击确认本协议之时起或使用你的铺子服务的行为发生之时起（以时间在先者为准）生效。如果您不同意本协议或其中任何条款约定，您应立即停止使用你的铺子服务。"}],
                        
                        @[
                            @{@"rowTitle":@"本协议由您与你的铺子共同缔结，本协议对您与你的铺子均具有合同效力。"},
                            @{@"rowTitle":@"本协议内的你的铺子，即你的铺子服务提供者，特指上海但来电子商务有限公司。"}
                            ],
                        @[@{@"rowTitle":@"由于互联网高速发展，本协议列明的条款并不能完整罗列并覆盖您与你的铺子的所有权利与义务，现有的约定也不能保证完全符合未来发展的需求。因此，各你的铺子服务所在客户端里的法律声明、隐私权政策及规则均为本协议的补充协议，与本协议不可分割且具有同等法律效力。如您使用你的铺子服务，视为您同意上述补充协议。"}
                          ],
                        @[@{@"rowTitle":@"您确认，您应当具备中华人民共和国法律规定的与您行为相适应的民事行为能力。若您不具备前述与您行为相适应的民事行为能力，则您及您的监护人应依照法律规定承担因此而导致的一切后果。"}
                          ],
                        @[@{@"rowTitle":@"您可通过你的铺子支持的账户（又称“账户”或“你的铺子账户”）类型登录你的铺子服务系统。您登录后，如要使用你的铺子服务进行推广的，还应先按页面提示填写信息、完成认证等以激活账户。"}
                          ],
                        @[@{@"rowTitle":@"由于用户账户关联用户信用等信息，仅有当法律明文规定、司法裁定或经你的铺子同意，并符合规则规定的账户转让流程的情况下，您可进行账户的转让。您的账户一经转让，该账户项下权利义务一并转移。除此外，您的账户不得以任何方式转让，否则由此产生的一切责任均由您承担"}
                          ],
                        @[@{@"rowTitle":@"在使用你的铺子服务时，您应当按系统页面的提示准确完整的提供您的信息。如有变更，应及时提供最新、真实、完整的信息，以便你的铺子或其他用户与您联系。您了解并同意，您有义务保持您提供信息的真实性及有效性。如你的铺子按您提供的信息与您联系未果、您未按你的铺子要求及时提供信息、您提供的信息存在明显不实的，你的铺子将按规则进行处理，同时您应承担因此对您自身、他人及你的铺子造成的全部损失与不利后果。"}
                          ],
                        @[@{@"rowTitle":@"您设置的店铺名、昵称应遵守你的铺子对其长度的要求，并不得违反国家法律法规及规则对此的管理规定。"}
                          ],
                        @[@{@"rowTitle":@"您的账户为您自行设置并由您保管，你的铺子任何时候均不会主动要求您提供您的账户。因此，建议您务必保管好您的账户，并确保您在每个上网时段结束时退出登录并以正确步骤离开你的铺子服务系统。账户因您主动泄露或遭受他人攻击、诈骗等行为导致的损失及后果，均由您自行承担。"}
                          ],
                        @[@{@"rowTitle":@"如发现任何未经授权使用您账户登录你的铺子服务系统或其他可能导致您账户遭窃、遗失的情况，建议您立即通知你的铺子，并授权你的铺子将该信息同步给你的铺子关联公司。您理解你的铺子对您的任何请求采取行动均需要合理时间，除你的铺子存在过错外，你的铺子对在采取行动前已经产生的后果不承担任何责任。"}
                          ],
                        @[@{@"rowTitle":@"您通过你的铺子服务系统可实现的功能包括但不限于如下，具体您可登录你的铺子服务系统浏览（下述功能可能因你的铺子进行业务、产品性调整而被增加或修改，或因定期、不定期的维护而暂缓提供）："},
                          @{@"rowTitle":@"（一）自行管理您的推广资源。"},
                          @{@"rowTitle":@"（二）自行获取推广信息，并在您的推广资源内推广。"},
                          @{@"rowTitle":@"（三）推广数据统计、收入结算，报表查询。"},
                          ],
                        @[@{@"rowTitle":@"您的推广权限以你的铺子服务系统开通或您实际推广时可使用的为准。"}
                          ],
                        @[@{@"rowTitle":@"你的铺子按年度收取技术服务费用，具体费用标准将在您激活账户或账户到期续展时另行通知。"},
                          @{@"rowTitle":@"你的铺子根据与战略合作单位达成的合作协议，减免战略合作单位推荐账户的年度技术服务费用。"}
                          ],
                        @[@{@"rowTitle":@"您使用你的铺子服务且不违反本协议时，您有权获得收入。收入将依据您推广引导的成交订单与您结算的。您可随时在你的铺子中查询您的预估收入。因可能存在的数据统计延后、消费者退货等原因，预估收入并非您的最终实际收入。您的实际收入及你的铺子付款主体以你的铺子提供的最终结算数据为准。通常情况下，您可按提现准则在一个月中提取二次收入金额。如遇重大事件或不可控因素影响支付日期的，你的铺子将提前另行通知。"},
                          ],
                        @[@{@"rowTitle":@"使用你的铺子服务过程中产生的应纳税费，以及一切硬件、软件、服务及其它方面的费用，由您自行承担。"},
                          ],
                        @[@{@"rowTitle":@"你的铺子非常重视用户个人信息（即能够独立或与其他信息结合后识别用户身份的信息）的保护，在您使用你的铺子提供的服务时，您同意你的铺子按照在你的铺子网站公布的隐私权政策收集、存储、使用、披露和保护您的个人信息。"},
                          ],
                        @[@{@"rowTitle":@"您声明并保证，您对您所发布的信息拥有相应、合法的权利。否则，你的铺子可对您发布的信息依法或依本协议进行删除或屏蔽。"},
                          ],
                        @[@{@"rowTitle":@"您应当确保您所发布的信息不包含以下内容："},
                          @{@"rowTitle":@"（一） 违反国家法律法规禁止性规定的。"},
                          @{@"rowTitle":@"（二） 政治宣传、封建迷信、淫秽、色情、赌博、暴力、恐怖或者教唆犯罪的。"},
                          @{@"rowTitle":@"（三） 欺诈、虚假、不准确或存在误导性的。"},
                          @{@"rowTitle":@"（四） 侵犯他人知识产权或涉及第三方商业秘密及其他专有权利的。"},
                          @{@"rowTitle":@"（五） 侮辱、诽谤、恐吓、涉及他人隐私等侵害他人合法权益的。"},
                          @{@"rowTitle":@"（六） 存在可能破坏、篡改、删除、影响你的铺子服务系统正常运行或未经授权秘密获取你的铺子服务系统及其他用户的数据、个人资料的病毒、木马、爬虫等恶意软件、程序代码的。"},
                          @{@"rowTitle":@"（七） 其他违背社会公共利益、公共道德，或依据规则规定不适合发布的。"},
                          ],
                        @[@{@"rowTitle":@"对于您在注册、激活账户或其他使用你的铺子服务过程中提供、形成的除个人信息外的文字、图片、视频、音频等非个人信息，您免费授予你的铺子及其关联公司获得全球的许可使用权利及再授权给其他第三方使用的权利。您同意你的铺子及其关联公司存储、使用、复制、修订、编辑、发布、展示、翻译、分发您的非个人信息或制作其派生作品，并以已知或日后开发的形式、媒体或技术将上述信息纳入其它作品内。"},
                          @{@"rowTitle":@"为方便您使用你的铺子及其关联公司提供的其他相关服务，您授权你的铺子将您在注册、激活账户或其他使用你的铺子服务过程中提供、形成的信息传递给其他相关服务提供者，或从其他相关服务提供者处获取您在注册、使用相关服务期间提供、形成的信息。"}
                          ],
                        @[@{@"rowTitle":@"发生如下情形之一的，视为您违约："},
                          @{@"rowTitle":@"（一） 使用你的铺子服务时违反相关法律法规规定的。"},
                          @{@"rowTitle":@"（二） 违反本协议或本协议补充协议约定的。"}
                          ],
                        @[@{@"rowTitle":@"你的铺子可对您及您的关联账户采取不结算收入、收回权限、终止合作等处理措施。同时，你的铺子可对您的违约行为处理措施信息，以及其他经国家行政或司法机关生效法律文书确认的违法信息在你的铺子服务系统内予以公示。"},
                          ],
                        @[@{@"rowTitle":@"如您的行为使你的铺子及/或其关联公司遭受损失（包括自身的直接经济损失、商誉损失及对外支付的赔偿金、和解款、律师费、诉讼费等间接经济损失），您应赔偿你的铺子及/或其关联公司的上述全部损失。"},
                          @{@"rowTitle":@"如您的行为使你的铺子及/或其关联公司遭受第三方主张权利，你的铺子及/或其关联公司可在对第三人承担金钱给付等义务后就全部损失向您追偿。"},
                          @{@"rowTitle":@"如你的铺子认定您的行为已经或者将必然导致第三方遭受损失，你的铺子及/或你的铺子关联公司出于第三方权益保护目的，可自应付您的费用中抵减，或指示支付宝公司、微信公司自您的支付宝账户、微信帐号中划扣相应款项进行支付。如仍不足支付相应款项的，您同意你的铺子可以使用自有资金代您支付上述款项，您应当返还该部分费用并赔偿因此造成你的铺子的全部损失。"},
                          @{@"rowTitle":@"对于您造成你的铺子及/或其关联公司、第三方的所有损失(包括你的铺子及/或其关联公司垫付款在内的上述所有情形)，您同意你的铺子可以自应付您的费用中抵减，或指示支付宝公司自您的支付宝账户中划扣相应款项支付上述赔偿款项。如仍不足支付上述赔偿款项的，你的铺子及/或你的铺子关联公司可直接抵减您在你的铺子及/或你的铺子关联公司其它协议项下的权益，并可继续追偿。"},
                          ],
                        @[
                            @{@"rowTitle":@"你的铺子可根据国家法律法规变化及维护合作秩序需要，不时修改本协议、补充协议，变更后的协议、补充协议（下称“变更事项”）将按本协议约定方式通知您。"},
                          @{@"rowTitle":@"如您不同意变更事项，您有权于变更事项确定的生效日前联系你的铺子反馈意见。如反馈意见得以采纳，你的铺子将酌情调整变更事项。"},
                          @{@"rowTitle":@"如您对已生效的变更事项仍不同意的，您应当于变更事项确定的生效之日起停止使用你的铺子服务，变更事项对您不产生效力；如您在变更事项生效后仍继续使用你的铺子服务的，则视为您同意已生效的变更事项。"},
                          ],
                        @[@{@"rowTitle":@"您同意你的铺子以以下任一合理的方式向您送达各类通知："},
                          @{@"rowTitle":@"（一） 公示的文案。"},
                          @{@"rowTitle":@"（二） 站内信、弹出消息、客户端推送消息。"},
                          @{@"rowTitle":@"（三） 根据您预留于你的铺子服务系统里的联系方式发出的电子邮件、短信、函件等。"},
                          ],
                        @[@{@"rowTitle":@"（一） 变更事项生效前您停止使用所有你的铺子服务，并明示不愿接受变更事项的。"},
                          @{@"rowTitle":@"（二） 您明示不愿继续使用所有你的铺子服务的。"},
                          ],
                        @[@{@"rowTitle":@"（一）您的账户未支付技术服务费用，被你的铺子依据本协议约定终止合作的。"},
                          @{@"rowTitle":@"（二）您的账户由你的铺子战略合作单位推荐，享受技术服务费减免政策，你的铺子有权根据战略合作单位通知，关停您的账户并终止本协议。"},
                          @{@"rowTitle":@"（三）您违反本协议其他约定，你的铺子依据本协议约定终止合作的。"},
                          ],
                        @[@{@"rowTitle":@"（一） 继续保存您留存于你的铺子服务系统的各类信息。"},
                          @{@"rowTitle":@"（二） 对于您过往的违约行为，你的铺子仍可依据本协议向您追究违约责任。"},
                          ],
                        @[@{@"rowTitle":@"【法律适用】本协议之订立、生效、解释、修订、补充、终止、执行与争议解决均适用中华人民共和国大陆地区法律；如法律无相关规定的，参照商业惯例及/或行业惯例。"},
                          @{@"rowTitle":@"【管辖】您因本协议所产生的任何争议，由你的铺子与您协商解决。协调不成时，任何一方均可向上海但来电子商务有限公司所在地有管辖权的人民法院提起诉讼。"},
                          @{@"rowTitle":@"【可分性】本协议任一条款被视为废止、无效或不可执行，该条应视为可分的且并不影响本协议其余条款的有效性及可执行性。"},
                          ],
                        
                        
                        ];
    return rowArr;
}

+ (NSArray *)getPurchaseSectionDescData {
    NSArray *sectionArr = @[@{@"sectionTitle":@"1.正品保证："},
                            @{@"sectionTitle":@"2.全场包邮："},
                            @{@"sectionTitle":@"3.关于发货："},
                            @{@"sectionTitle":@"4.关于快递："},
                            @{@"sectionTitle":@"5.关于签收："},
                            @{@"sectionTitle":@"6.关于退换货："},
                            @{@"sectionTitle":@"7.联系客服："},
                            
                            ];
    return sectionArr;
}
+ (NSArray *)getPurchaseRowDescData {
    NSArray *rowArr = @[
                        @[@{@"rowTitle":@"您的铺子所有商品均从海内外正规供货商或品牌商直供，货源正品保障。"},],
                        
                        @[
                            @{@"rowTitle":@"你的铺子全场商品支持全国范围内包邮（港澳台除外），暂不支持寄往港澳台和国外。"},
                            ],
                        @[@{@"rowTitle":@"a.国内自营商品：一般24小时发货，发货后3－5天到货，如遇大促销活动及快递爆仓等情况会有所延迟。"},
                          @{@"rowTitle":@"b.国内保税区商品：一般情况下您的订单经审核后交由海关清关，清关完成后由保税区发区，一般需要5-14个工作日左右完成发货，发货后3-10个工作日左右到货，因涉及海关清关、节假日及物流等因素可能会有所延迟。"},
                          @{@"rowTitle":@"c.品牌直发商品：品牌方自营商品，将由品牌方自行安排发货，具体发货事宜可参考商品详情页说明。"},
                          ],
                        @[@{@"rowTitle":@"你的铺子仓储与多家快递公司合作，保证所有国内地区均有快递可以送达，暂不支持指定的快递。"}
                          ],
                        @[@{@"rowTitle":@"收到商品后需要您当场验货确认无误后再签收，如果是包装完好且本人签收后再反馈少发、错发等类似问题，请自理。若非当面签收后发现异常请第一时间联系快递核实。"}
                          ],
                        @[@{@"rowTitle":@"6.1无理由退货：在产品完好不影响二次销售的情况下，支持收货后7天无理由换货（蔬果生鲜/食品饮料/保健滋补/计生/特卖、抢购/美妆护理/珠宝/饰品/钟表/眼镜，保税区及其他页面特别说明商品不支持无理由退换货），换货寄回运费需买家承担。"},
                          @{@"rowTitle":@"6.2非无理由退换货：因商品质量问题，破损错发等非买家原因导致的退货（蔬果生鲜/过敏、快递延迟等除外），支持收货后7天内退换货，来回运费由你的铺子承担。"}
                          ],
                        @[@{@"rowTitle":@"7.1客服电话：（服务时间9：00-18：00）"},
                          @{@"rowTitle":@"7.2通过你的铺子服务号：（nidepuzi）或你的铺子APP中客服直接联系在线客服，客服在线时间9：00-18：00，节假日正常工作。(客服不在线时间请留言，客服上线后会第一时间为您处理问题。) "},
                          ],
                       
                        ];
    return rowArr;
}


+ (NSArray *)getWithdrawSectionDescData {
    NSArray *sectionArr = @[@{@"sectionTitle":@"1.我什么时候可以提现？"},
                            @{@"sectionTitle":@"2.提现有什么要求？"},
                            @{@"sectionTitle":@"3.提现什么时候可以到账？"},
                            @{@"sectionTitle":@"4.审核日是什么时候？对应审核的时间规范是什么？"},
                            @{@"sectionTitle":@"5.如果我不知道出什么问题了，怎么办？"},
                            ];
    return sectionArr;
}
+ (NSArray *)getWithdrawRowDescData {
    NSArray *rowArr = @[
                        @[@{@"rowTitle":@"(1) 随时都可以"},],
                        
                        @[
                            @{@"rowTitle":@"(1) 需要您个人信息与银行卡保持一致，并且银行卡信息完整无误"},
                            @{@"rowTitle":@"(2) 提现金额最低10元"},
                            ],
                        @[@{@"rowTitle":@"(1) 通常你的铺子审核日后3个工作日（具体视银行结算）"},
                          ],
                        @[@{@"rowTitle":@"(1) 审核日是每个月的9号和24号。"},
                          @{@"rowTitle":@"(2) 9号审核时间范围：上月24号17:01至本月9号10:00"}
                          ],
                        @[@{@"rowTitle":@"(1) 请联系你的铺子服务号nidepuzi"}
                          ],
                        ];
    return rowArr;
}



@end













































































