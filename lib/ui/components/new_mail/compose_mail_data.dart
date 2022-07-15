import 'package:json_annotation/json_annotation.dart';
part 'compose_mail_data.g.dart';

@JsonSerializable()
class ComposeMailData {
  String fromEmail;
  List<String> toEmails;
  String replyTo;
  List<String> ccEmails;
  List<String> bccEmails;
  String subject;
  String content;

  ComposeMailData(this.fromEmail, this.toEmails, this.replyTo, this.ccEmails, this.bccEmails, this.subject, this.content);

  factory ComposeMailData.fromJson(Map<String, dynamic> json) => _$ComposeMailDataFromJson(json);

  Map<String, dynamic> toJson() => _$ComposeMailDataToJson(this);
}
