import { Component, OnInit } from '@angular/core';

export interface myModel {
  title?: string;
  description?: string;
}

@Component({
  selector: 'app-mailboxfolders',
  templateUrl: './mailboxfolders.component.html',
  styleUrls: ['./mailboxfolders.component.scss']
})
export class MailboxfoldersComponent implements OnInit {
  items: Array<myModel> = [
    { title: "Gmail", description: "default item description" },
    { title: "Starred", description: "default item description" },
    { title: "Important", description: "default item description" },
    { title: "Workplace", description: "default item description" },
    { title: "Invoices", description: "default item description" },
    { title: "Private", description: "default item description" },
    { title: "Travel", description: "default item description" },
    { title: "Shopping", description: "default item description" },
    { title: "Deleted", description: "default item description" },
  ];  
  constructor() { }

  ngOnInit(): void {
  }

}
