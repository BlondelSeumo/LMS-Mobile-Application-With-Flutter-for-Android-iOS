class AboutUsModel {
  AboutUsModel({
    this.about,
  });

  List<About> about;

  factory AboutUsModel.fromJson(Map<String, dynamic> json) => AboutUsModel(
        about: List<About>.from(json["about"].map((x) => About.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "about": List<dynamic>.from(about.map((x) => x.toJson())),
      };
}

class About {
  About({
    this.id,
    this.oneEnable,
    this.oneHeading,
    this.oneImage,
    this.oneText,
    this.twoEnable,
    this.twoHeading,
    this.twoText,
    this.twoImageone,
    this.twoImagetwo,
    this.twoImagethree,
    this.twoImagefour,
    this.twoTxtone,
    this.twoTxttwo,
    this.twoTxtthree,
    this.twoTxtfour,
    this.twoImagetext,
    this.threeEnable,
    this.threeHeading,
    this.threeText,
    this.threeCountone,
    this.threeCounttwo,
    this.threeCountthree,
    this.threeCountfour,
    this.threeCountfive,
    this.threeCountsix,
    this.threeTxtone,
    this.threeTxttwo,
    this.threeTxtthree,
    this.threeTxtfour,
    this.threeTxtfive,
    this.threeTxtsix,
    this.fourEnable,
    this.fourHeading,
    this.fourText,
    this.fourBtntext,
    this.fourImageone,
    this.fourImagetwo,
    this.fourTxtone,
    this.fourTxttwo,
    this.fourIcon,
    this.fiveEnable,
    this.fiveHeading,
    this.fiveText,
    this.fiveBtntext,
    this.fiveImageone,
    this.fiveImagetwo,
    this.fiveImagethree,
    this.sixEnable,
    this.sixHeading,
    this.sixTxtone,
    this.sixTxttwo,
    this.sixTxtthree,
    this.sixDeatilone,
    this.sixDeatiltwo,
    this.sixDeatilthree,
    this.textOne,
    this.textTwo,
    this.textThree,
    this.linkOne,
    this.linkTwo,
    this.linkThree,
    this.linkFour,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  dynamic oneEnable;
  String oneHeading;
  String oneImage;
  String oneText;
  dynamic twoEnable;
  String twoHeading;
  String twoText;
  String twoImageone;
  String twoImagetwo;
  String twoImagethree;
  String twoImagefour;
  String twoTxtone;
  String twoTxttwo;
  String twoTxtthree;
  String twoTxtfour;
  String twoImagetext;
  dynamic threeEnable;
  String threeHeading;
  String threeText;
  String threeCountone;
  String threeCounttwo;
  String threeCountthree;
  String threeCountfour;
  String threeCountfive;
  String threeCountsix;
  String threeTxtone;
  String threeTxttwo;
  String threeTxtthree;
  String threeTxtfour;
  String threeTxtfive;
  String threeTxtsix;
  dynamic fourEnable;
  String fourHeading;
  String fourText;
  String fourBtntext;
  String fourImageone;
  String fourImagetwo;
  String fourTxtone;
  String fourTxttwo;
  String fourIcon;
  dynamic fiveEnable;
  String fiveHeading;
  String fiveText;
  String fiveBtntext;
  String fiveImageone;
  String fiveImagetwo;
  String fiveImagethree;
  dynamic sixEnable;
  String sixHeading;
  String sixTxtone;
  String sixTxttwo;
  String sixTxtthree;
  String sixDeatilone;
  String sixDeatiltwo;
  String sixDeatilthree;
  String textOne;
  String textTwo;
  String textThree;
  dynamic linkOne;
  dynamic linkTwo;
  dynamic linkThree;
  dynamic linkFour;
  DateTime createdAt;
  DateTime updatedAt;

  factory About.fromJson(Map<String, dynamic> json) => About(
        id: json["id"],
        oneEnable: json["one_enable"],
        oneHeading: json["one_heading"],
        oneImage: json["one_image"],
        oneText: json["one_text"],
        twoEnable: json["two_enable"],
        twoHeading: json["two_heading"],
        twoText: json["two_text"],
        twoImageone: json["two_imageone"],
        twoImagetwo: json["two_imagetwo"],
        twoImagethree: json["two_imagethree"],
        twoImagefour: json["two_imagefour"],
        twoTxtone: json["two_txtone"],
        twoTxttwo: json["two_txttwo"],
        twoTxtthree: json["two_txtthree"],
        twoTxtfour: json["two_txtfour"],
        twoImagetext: json["two_imagetext"],
        threeEnable: json["three_enable"],
        threeHeading: json["three_heading"],
        threeText: json["three_text"],
        threeCountone: json["three_countone"],
        threeCounttwo: json["three_counttwo"],
        threeCountthree: json["three_countthree"],
        threeCountfour: json["three_countfour"],
        threeCountfive: json["three_countfive"],
        threeCountsix: json["three_countsix"],
        threeTxtone: json["three_txtone"],
        threeTxttwo: json["three_txttwo"],
        threeTxtthree: json["three_txtthree"],
        threeTxtfour: json["three_txtfour"],
        threeTxtfive: json["three_txtfive"],
        threeTxtsix: json["three_txtsix"],
        fourEnable: json["four_enable"],
        fourHeading: json["four_heading"],
        fourText: json["four_text"],
        fourBtntext: json["four_btntext"],
        fourImageone: json["four_imageone"],
        fourImagetwo: json["four_imagetwo"],
        fourTxtone: json["four_txtone"],
        fourTxttwo: json["four_txttwo"],
        fourIcon: json["four_icon"],
        fiveEnable: json["five_enable"],
        fiveHeading: json["five_heading"],
        fiveText: json["five_text"],
        fiveBtntext: json["five_btntext"],
        fiveImageone: json["five_imageone"],
        fiveImagetwo: json["five_imagetwo"],
        fiveImagethree: json["five_imagethree"],
        sixEnable: json["six_enable"],
        sixHeading: json["six_heading"],
        sixTxtone: json["six_txtone"],
        sixTxttwo: json["six_txttwo"],
        sixTxtthree: json["six_txtthree"],
        sixDeatilone: json["six_deatilone"],
        sixDeatiltwo: json["six_deatiltwo"],
        sixDeatilthree: json["six_deatilthree"],
        textOne: json["text_one"],
        textTwo: json["text_two"],
        textThree: json["text_three"],
        linkOne: json["link_one"],
        linkTwo: json["link_two"],
        linkThree: json["link_three"],
        linkFour: json["link_four"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "one_enable": oneEnable,
        "one_heading": oneHeading,
        "one_image": oneImage,
        "one_text": oneText,
        "two_enable": twoEnable,
        "two_heading": twoHeading,
        "two_text": twoText,
        "two_imageone": twoImageone,
        "two_imagetwo": twoImagetwo,
        "two_imagethree": twoImagethree,
        "two_imagefour": twoImagefour,
        "two_txtone": twoTxtone,
        "two_txttwo": twoTxttwo,
        "two_txtthree": twoTxtthree,
        "two_txtfour": twoTxtfour,
        "two_imagetext": twoImagetext,
        "three_enable": threeEnable,
        "three_heading": threeHeading,
        "three_text": threeText,
        "three_countone": threeCountone,
        "three_counttwo": threeCounttwo,
        "three_countthree": threeCountthree,
        "three_countfour": threeCountfour,
        "three_countfive": threeCountfive,
        "three_countsix": threeCountsix,
        "three_txtone": threeTxtone,
        "three_txttwo": threeTxttwo,
        "three_txtthree": threeTxtthree,
        "three_txtfour": threeTxtfour,
        "three_txtfive": threeTxtfive,
        "three_txtsix": threeTxtsix,
        "four_enable": fourEnable,
        "four_heading": fourHeading,
        "four_text": fourText,
        "four_btntext": fourBtntext,
        "four_imageone": fourImageone,
        "four_imagetwo": fourImagetwo,
        "four_txtone": fourTxtone,
        "four_txttwo": fourTxttwo,
        "four_icon": fourIcon,
        "five_enable": fiveEnable,
        "five_heading": fiveHeading,
        "five_text": fiveText,
        "five_btntext": fiveBtntext,
        "five_imageone": fiveImageone,
        "five_imagetwo": fiveImagetwo,
        "five_imagethree": fiveImagethree,
        "six_enable": sixEnable,
        "six_heading": sixHeading,
        "six_txtone": sixTxtone,
        "six_txttwo": sixTxttwo,
        "six_txtthree": sixTxtthree,
        "six_deatilone": sixDeatilone,
        "six_deatiltwo": sixDeatiltwo,
        "six_deatilthree": sixDeatilthree,
        "text_one": textOne,
        "text_two": textTwo,
        "text_three": textThree,
        "link_one": linkOne,
        "link_two": linkTwo,
        "link_three": linkThree,
        "link_four": linkFour,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
