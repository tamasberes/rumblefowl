import { Component, OnInit } from '@angular/core';
import { FormControl, FormGroupDirective, NgForm, Validators } from '@angular/forms';
import { ErrorStateMatcher } from '@angular/material/core';
import { MatDialog } from '@angular/material/dialog';
import { NGXLogger } from 'ngx-logger';
import { MailboxesService } from '../mailbox/mailboxes.service';
import { MailboxSettings } from '../mailbox/MailboxSettings';
import { myModel } from '../mailboxfolders/mailboxfolders.component';

@Component({
  selector: 'app-managemailboxes',
  templateUrl: './managemailboxes.component.html',
  styleUrls: ['./managemailboxes.component.scss']
})
export class ManagemailboxesComponent implements OnInit {
  items: Array<MailboxSettings>;
  selectedMalbox!: MailboxSettings;

  constructor(public dialog: MatDialog, private mailboxesService: MailboxesService, private logger: NGXLogger) {
    this.items = mailboxesService.get();
    this.onEmailAdressSelected(this.items[0]);
  }

  openDialog() {

  }

  ngOnInit(): void {
  }

  onEmailAdressSelected(item: MailboxSettings) {
    this.logger.debug("onEmailAdressSelected:" + item);
    this.selectedMalbox = item;
  }

  onvalueChange(event: any) {
    this.logger.debug("onvalueChange:" + event);
    if (this.isInputValid(this.selectedMalbox)) {
      this.mailboxesService.update(this.selectedMalbox);
    }
  }

  isInputValid(item: MailboxSettings) {
    return true; //FIXME input validation
  }

  onAddNewMailboxClicked() {
    this.mailboxesService.addNew();
    this.items = this.mailboxesService.get();
    
  }
}

