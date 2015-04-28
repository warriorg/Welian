//
//  IFriend2Model.h
//  Welian
//
//  Created by weLian on 15/4/28.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IFBase.h"

@interface IFriend2Model : IFBase

/**  2度好友数量   */
@property (nonatomic, strong) NSNumber *friendCount;

@property (nonatomic, strong) NSArray *friends;

@end

/*
 count = 1505;
 friends =     (
 {
 avatar = "http://img.welian.com/1428028030418-200-200_x.jpg";
 company = "\U676d\U5dde\U4f20\U9001\U95e8\U7f51\U7edc\U79d1\U6280\U6709\U9650\U516c\U53f8";
 investorauth = "-1";
 name = "\U9676\U4e9a\U6960\Ud83d\Ude0a";
 position = "\U5b89\U5353\U5f00\U53d1";
 samefriendcount = 15;
 samefriends =             (
 {
 avatar = "http://img.welian.com/upload/1411739683396_x.jpg";
 company = "\U5fae\U94fe";
 investorauth = "-1";
 name = "\U67f3\U8363\U519b";
 position = "\U8054\U5408\U521b\U59cb\U4eba";
 uid = 10040;
 },
 {
 avatar = "http://img.welian.com/upload/1412956126686_x.png";
 company = "\U8fed\U4ee3\U8d44\U672c";
 investorauth = 1;
 name = "\U8521\U534e";
 position = "\U5408\U4f19\U4eba";
 uid = 10041;
 }
 );
 uid = 10053;
 },
 {
 avatar = "http://img.welian.com/1425521699661-200-200_x.jpg";
 company = "\U676d\U5dde\U4f20\U9001\U95e8\U7f51\U7edc\U79d1\U6280\U6709\U9650\U516c\U53f8";
 investorauth = "-1";
 name = "\U8e47\U5146\U6587";
 position = "\U8f6f\U4ef6\U5de5\U7a0b\U5e08";
 samefriendcount = 15;
 samefriends =             (
 {
 avatar = "http://img.welian.com/upload/1411739683396_x.jpg";
 company = "\U5fae\U94fe";
 investorauth = "-1";
 name = "\U67f3\U8363\U519b";
 position = "\U8054\U5408\U521b\U59cb\U4eba";
 
 uid = 10040;
 },
 {
 avatar = "http://img.welian.com/upload/1412956126686_x.png";
 company = "\U8fed\U4ee3\U8d44\U672c";
 investorauth = 1;
 name = "\U8521\U534e";
 position = "\U5408\U4f19\U4eba";
 uid = 10041;
 }
 );
 uid = 10061;
 },
 {
 avatar = "http://img.welian.com/1420515029977-200-194_x.png";
 company = "\U5fae\U94fe";
 investorauth = "-1";
 name = Test;
 position = "\U8f6f\U4ef6\U5de5\U7a0b\U5e08";
 samefriendcount = 13;
 samefriends =             (
 {
 avatar = "http://img.welian.com/upload/1411739683396_x.jpg";
 company = "\U5fae\U94fe";
 investorauth = "-1";
 name = "\U67f3\U8363\U519b";
 position = "\U8054\U5408\U521b\U59cb\U4eba";
 uid = 10040;
 },
 {
 avatar = "http://img.welian.com/upload/1412956126686_x.png";
 company = "\U8fed\U4ee3\U8d44\U672c";
 investorauth = 1;
 name = "\U8521\U534e";
 position = "\U5408\U4f19\U4eba";
 uid = 10041;
 }
 );
 uid = 10056;
 },
 {
 avatar = "http://img.welian.com/1423141735232-200-200_x.jpg";
 company = "\U676d\U5dde\U4f20\U9001\U95e8\U7f51\U7edc\U79d1\U6280\U6709\U9650\U516c\U53f8";
 investorauth = "-1";
 name = "\U4e50\U5c0f\U6dd8UNO\U7834\U9b54\U5973\U54af";
 position = "Android\U5f00\U53d1\U5de5\U7a0b";
 samefriendcount = 12;
 samefriends =             (
 {
 avatar = "http://img.welian.com/upload/1411739683396_x.jpg";
 company = "\U5fae\U94fe";
 investorauth = "-1";
 name = "\U67f3\U8363\U519b";
 position = "\U8054\U5408\U521b\U59cb\U4eba";
 uid = 10040;
 },
 {
 avatar = "http://img.welian.com/upload/1412956126686_x.png";
 company = "\U8fed\U4ee3\U8d44\U672c";
 investorauth = 1;
 name = "\U8521\U534e";
 position = "\U5408\U4f19\U4eba";
 uid = 10041;
 }
 );
 uid = 10029;
 },
 {
 avatar = "http://img.welian.com/1423142344352-200-200_x.jpg";
 company = "\U676d\U5ddek9\U72ac\U4e1a\U4ff1\U4e50\U90e8";
 investorauth = 0;
 name = "K9\U72ac\U4e1a\U4ff1\U4e50\U90e8";
 position = "\U521b\U59cb\U4eba";
 samefriendcount = 10;
 samefriends =             (
 {
 avatar = "http://img.welian.com/upload/1412956126686_x.png";
 company = "\U8fed\U4ee3\U8d44\U672c";
 investorauth = 1;
 name = "\U8521\U534e";
 position = "\U5408\U4f19\U4eba";
 uid = 10041;
 },
 {
 avatar = "http://img.welian.com/1426770089681-200-200_x.jpg";
 company = "\U676d\U5dde\U4f20\U9001\U95e8\U7f51\U7edc";
 investorauth = "-1";
 name = "\U5434\U5b66\U662d";
 position = PHPer;
 uid = 10046;
 }
 );
 uid = 11339;
 },
 {
 avatar = "http://img.welian.com/1414685493834_x.png";
 company = "TechDaily\U300c\U66f4\U65b0\U9510\U7684\U521b\U4e1a\U5a92\U4f53\U300d";
 investorauth = 0;
 name = "\U5f90\U4f1f";
 position = "\U521b\U59cb\U4eba";
 samefriendcount = 10;
 samefriends =             (
 {
 avatar = "http://img.welian.com/upload/1411739683396_x.jpg";
 company = "\U5fae\U94fe";
 investorauth = "-1";
 name = "\U67f3\U8363\U519b";
 position = "\U8054\U5408\U521b\U59cb\U4eba";
 uid = 10040;
 },
 {
 avatar = "http://img.welian.com/upload/1412956126686_x.png";
 company = "\U8fed\U4ee3\U8d44\U672c";
 investorauth = 1;
 name = "\U8521\U534e";
 position = "\U5408\U4f19\U4eba";
 uid = 10041;
 }
 );
 uid = 10103;
 },
 {
 avatar = "http://img.welian.com/1421163955639-200-200_x.jpg";
 company = "\U5fae\U94fe";
 investorauth = 0;
 name = "\U9648\U901a";
 position = "\U4ea7\U54c1\U7ecf\U7406";
 samefriendcount = 9;
 samefriends =             (
 {
 avatar = "http://img.welian.com/upload/1411739683396_x.jpg";
 company = "\U5fae\U94fe";
 investorauth = "-1";
 name = "\U67f3\U8363\U519b";
 position = "\U8054\U5408\U521b\U59cb\U4eba";
 uid = 10040;
 },
 {
 avatar = "http://img.welian.com/upload/1412956126686_x.png";
 company = "\U8fed\U4ee3\U8d44\U672c";
 investorauth = 1;
 name = "\U8521\U534e";
 position = "\U5408\U4f19\U4eba";
 uid = 10041;
 }
 );
 uid = 11316;
 },
 {
 avatar = "http://img.welian.com/1414828686594_x.png";
 company = "\U8fed\U4ee3\U8d44\U672c";
 investorauth = 1;
 name = "\U5468\U54cd\U4e1c";
 position = "\U5408\U4f19\U4eba";
 samefriendcount = 9;
 samefriends =             (
 {
 avatar = "http://img.welian.com/upload/1411739683396_x.jpg";
 company = "\U5fae\U94fe";
 investorauth = "-1";
 name = "\U67f3\U8363\U519b";
 position = "\U8054\U5408\U521b\U59cb\U4eba";
 uid = 10040;
 },
 {
 avatar = "http://img.welian.com/upload/1412956126686_x.png";
 company = "\U8fed\U4ee3\U8d44\U672c";
 investorauth = 1;
 name = "\U8521\U534e";
 position = "\U5408\U4f19\U4eba";
 uid = 10041;
 }
 );
 uid = 10091;
 },
 {
 avatar = "http://img.welian.com/1414688630331_x.jpg";
 company = "\U5fae\U94fe";
 investorauth = "-1";
 name = damy;
 position = "\U6253\U6742\U6ef4";
 samefriendcount = 8;
 samefriends =             (
 {
 avatar = "http://img.welian.com/upload/1411739683396_x.jpg";
 company = "\U5fae\U94fe";
 investorauth = "-1";
 name = "\U67f3\U8363\U519b";
 position = "\U8054\U5408\U521b\U59cb\U4eba";
 uid = 10040;
 },
 {
 avatar = "http://img.welian.com/upload/1412956126686_x.png";
 company = "\U8fed\U4ee3\U8d44\U672c";
 investorauth = 1;
 name = "\U8521\U534e";
 position = "\U5408\U4f19\U4eba";
 uid = 10041;
 }
 );
 uid = 10039;
 },
 {
 avatar = "http://img.welian.com/1421160191315-200-199_x.jpg";
 company = "\U7f51\U7edc";
 investorauth = 0;
 name = "\U5f20\U8273";
 position = PK;
 samefriendcount = 7;
 samefriends =             (
 {
 avatar = "http://img.welian.com/upload/1412956126686_x.png";
 company = "\U8fed\U4ee3\U8d44\U672c";
 investorauth = 1;
 name = "\U8521\U534e";
 position = "\U5408\U4f19\U4eba";
 uid = 10041;
 },
 {
 avatar = "http://img.welian.com/http://pic1.ooopic.com/uploadfilepic/sheji/2009-05-05/OOOPIC_vip4_20090505079ae095187332ea.jpg";
 company = weLian;
 investorauth = 0;
 name = "\U5f20\U8273\U4e1c";
 position = "\U5a92\U4f53\U4eba     ";
 uid = 20608;
 }
 );
 uid = 11311;
 },
 {
 avatar = "http://img.welian.com/1425961571744-200-200_x.png";
 company = "\U4e2a\U63a8";
 investorauth = 1;
 name = "\U82b1\U59d0";
 position = "\U8001\U677f\U5a18";
 samefriendcount = 6;
 samefriends =             (
 {
 avatar = "http://img.welian.com/upload/1411739683396_x.jpg";
 company = "\U5fae\U94fe";
 investorauth = "-1";
 name = "\U67f3\U8363\U519b";
 position = "\U8054\U5408\U521b\U59cb\U4eba";
 uid = 10040;
 },
 {
 avatar = "http://img.welian.com/upload/1412956126686_x.png";
 company = "\U8fed\U4ee3\U8d44\U672c";
 investorauth = 1;
 name = "\U8521\U534e";
 position = "\U5408\U4f19\U4eba";
 uid = 10041;
 }
 );
 uid = 10245;
 },
 {
 avatar = "http://img.welian.com/1415199394323_x.jpg";
 company = "\U6d59\U6c5f\U5927\U5b66";
 investorauth = 0;
 name = "\U9752\U9752blue";
 position = "\U5b66\U751f";
 samefriendcount = 6;
 samefriends =             (
 {
 avatar = "http://img.welian.com/upload/1411739683396_x.jpg";
 company = "\U5fae\U94fe";
 investorauth = "-1";
 name = "\U67f3\U8363\U519b";
 position = "\U8054\U5408\U521b\U59cb\U4eba";
 uid = 10040;
 },
 {
 avatar = "http://img.welian.com/upload/1412956126686_x.png";
 company = "\U8fed\U4ee3\U8d44\U672c";
 investorauth = 1;
 name = "\U8521\U534e";
 position = "\U5408\U4f19\U4eba";
 uid = 10041;
 }
 );
 uid = 10262;
 },
 {
 avatar = "http://img.welian.com/1415688612259_x.jpg";
 company = weLian;
 investorauth = 0;
 name = "\U8e47\U5146\U6587";
 position = "\U7b97\U6cd5\U5de5\U7a0b\U5e08";
 samefriendcount = 6;
 samefriends =             (
 {
 avatar = "http://img.welian.com/http://pic1.ooopic.com/uploadfilepic/sheji/2009-05-05/OOOPIC_vip4_20090505079ae095187332ea.jpg";
 company = weLian;
 investorauth = 0;
 name = "\U5f20\U8273\U4e1c";
 position = "\U5a92\U4f53\U4eba     ";
 uid = 20608;
 },
 {
 avatar = "http://img.welian.com/http://pic1.ooopic.com/uploadfilepic/sheji/2009-05-05/OOOPIC_vip4_20090505079ae095187332ea.jpg";
 company = weLian;
 investorauth = 0;
 name = Zhang;
 position = "Android\U5f00\U53d1\U5de5\U7a0b\U5e08";
 uid = 20609;
 }
 );
 uid = 10358;
 },
 {
 avatar = "http://img.welian.com/1415772840417_x.jpg";
 company = "\U7a7a";
 investorauth = 0;
 name = "\U54af\U561b";
 position = "\U989d\U5ea6";
 samefriendcount = 6;
 samefriends =             (
 {
 avatar = "http://img.welian.com/http://pic1.ooopic.com/uploadfilepic/sheji/2009-05-05/OOOPIC_vip4_20090505079ae095187332ea.jpg";
 company = weLian;
 investorauth = 0;
 name = "\U5f20\U8273\U4e1c";
 position = "\U5a92\U4f53\U4eba     ";
 uid = 20608;
 },
 {
 avatar = "http://img.welian.com/http://pic1.ooopic.com/uploadfilepic/sheji/2009-05-05/OOOPIC_vip4_20090505079ae095187332ea.jpg";
 company = weLian;
 investorauth = 0;
 name = Zhang;
 position = "Android\U5f00\U53d1\U5de5\U7a0b\U5e08";
 uid = 20609;
 }
 );
 uid = 10374;
 },
 {
 avatar = "http://img.welian.com/1416148407711_x.jpg";
 company = "\U6d59\U5546\U94f6\U884c\U676d\U5dde\U57ce\U897f\U652f\U884c";
 investorauth = 0;
 name = "\U6797\U514b\U975e";
 position = "\U526f\U603b\U7ecf\U7406";
 samefriendcount = 6;
 samefriends =             (
 {
 avatar = "http://img.welian.com/upload/1411739683396_x.jpg";
 company = "\U5fae\U94fe";
 investorauth = "-1";
 name = "\U67f3\U8363\U519b";
 position = "\U8054\U5408\U521b\U59cb\U4eba";
 uid = 10040;
 },
 {
 avatar = "http://img.welian.com/upload/1412956126686_x.png";
 company = "\U8fed\U4ee3\U8d44\U672c";
 investorauth = 1;
 name = "\U8521\U534e";
 position = "\U5408\U4f19\U4eba";
 uid = 10041;
 }
 );
 uid = 10474;
 },
 {
 avatar = "http://img.welian.com/1417512631237-200-200_x.png";
 company = "\U676d\U5dde\U4f20\U9001\U95e8\U7f51\U7edc\U79d1\U6280\U6709\U9650\U516c\U53f8";
 investorauth = 0;
 name = "\U5146\U6587";
 position = "\U7b97\U6cd5\U5de5\U7a0b\U5e08";
 samefriendcount = 6;
 samefriends =             (
 {
 avatar = "http://img.welian.com/http://pic1.ooopic.com/uploadfilepic/sheji/2009-05-05/OOOPIC_vip4_20090505079ae095187332ea.jpg";
 company = weLian;
 investorauth = 0;
 name = "\U5f20\U8273\U4e1c";
 position = "\U5a92\U4f53\U4eba     ";
 uid = 20608;
 },
 {
 avatar = "http://img.welian.com/http://pic1.ooopic.com/uploadfilepic/sheji/2009-05-05/OOOPIC_vip4_20090505079ae095187332ea.jpg";
 company = weLian;
 investorauth = 0;
 name = Zhang;
 position = "Android\U5f00\U53d1\U5de5\U7a0b\U5e08";
 uid = 20609;
 }
 );
 uid = 10567;
 }
 );
 }
 
 */