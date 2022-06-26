import { Injectable } from '@angular/core';
import { MailboxSettings } from './MailboxSettings';
import { NGXLogger } from 'ngx-logger';

@Injectable({
  providedIn: 'root'
})
export class MailboxesService {

  constructor(private logger: NGXLogger) { }

  //FIXME test data
  getMailboxes(): Array<MailboxSettings> {
    var testData = new Array<MailboxSettings>();

    var test: MailboxSettings = {
      title: "firstAccount",
      userName: "username",
      emailAddress: "testaddress@example.com",
      signature: "byez",
      imapUrl: "imap.googlemail.com",
      imapUserName: "testaddress@examle.com",
      imapPort: 993
    }

    for (let index = 0; index < 25; index++) {
      testData.push(test);
    }
    this.logger.debug("test data", testData);
    return testData
  }

  upadteMailbox(mailbox: MailboxSettings) {

  }
}
