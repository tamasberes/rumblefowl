import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { MailboxesService } from '../mailbox/mailboxes.service';
import { MailboxSettings } from '../mailbox/MailboxSettings';
import { myModel } from '../mailboxfolders/mailboxfolders.component';

@Component({
  selector: 'app-managemailboxes',
  templateUrl: './managemailboxes.component.html',
  styleUrls: ['./managemailboxes.component.scss']
})
export class ManagemailboxesComponent implements OnInit {

  constructor(public dialog: MatDialog, private mailbox: MailboxesService) {
    this.items=mailbox.getMailboxes()
  }
  
  items: Array<MailboxSettings>;

  openDialog() {
    
  }

  ngOnInit(): void {
  }

}
