import { Injectable } from '@angular/core';
import { MailboxSettings } from './MailboxSettings';
import { NGXLogger } from 'ngx-logger';
import { MatExpansionPanelDescription } from '@angular/material/expansion';

@Injectable({
  providedIn: 'root'
})
export class MailboxesService {

  constructor(private logger: NGXLogger) { }

  get(): MailboxSettings[] {
    var storedData = localStorage.getItem('mailboxes');
    if (storedData == null) {
      var defaultResult = new Array<MailboxSettings>();
      var test = this.getNewMailbox(0)
      defaultResult.push(test);
      localStorage.setItem("mailboxes", JSON.stringify(defaultResult));
      storedData = localStorage.getItem('mailboxes');
    }
    return JSON.parse(storedData!) as MailboxSettings[];
  }

  getNewMailbox(index: number): MailboxSettings {
    var result: MailboxSettings = {
      index: index,
      userName: "test@example.com",
      emailAddress: "test@example.com",
      signature: "Best regards",
      imapUrl: "imap.googlemail.com",
      imapUserName: "test@example.com",
      imapPort: 993
    }
    return result;
  }

  set(mailboxSettings: MailboxSettings[]) {
    localStorage.setItem("mailboxes", JSON.stringify(mailboxSettings));
    this.logger.debug("set done");
  }

  update(mailbox: MailboxSettings) {
    var data = this.get();
    var foundData = data.findIndex((x) => x.index === mailbox.index);
    if (foundData < 0) {
      throw "error"
    }
    data[foundData] = mailbox;
    this.set(data);
  }

  addNew() {
    var current = this.get();
    this.add(this.getNewMailbox(current.length));
  }

  add(mailbox: MailboxSettings) {
    var items = this.get();
    items.push(mailbox);
    this.set(items);
  }

}
