// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compose_mail_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComposeMailData _$ComposeMailDataFromJson(Map<String, dynamic> json) =>
    ComposeMailData(
      json['fromEmail'] as String,
      (json['toEmails'] as List<dynamic>).map((e) => e as String).toList(),
      json['replyTo'] as String,
      (json['ccEmails'] as List<dynamic>).map((e) => e as String).toList(),
      (json['bccEmails'] as List<dynamic>).map((e) => e as String).toList(),
      json['subject'] as String,
      json['content'] as String,
    );

Map<String, dynamic> _$ComposeMailDataToJson(ComposeMailData instance) =>
    <String, dynamic>{
      'fromEmail': instance.fromEmail,
      'toEmails': instance.toEmails,
      'replyTo': instance.replyTo,
      'ccEmails': instance.ccEmails,
      'bccEmails': instance.bccEmails,
      'subject': instance.subject,
      'content': instance.content,
    };
