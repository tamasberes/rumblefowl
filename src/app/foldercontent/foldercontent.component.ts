import { Component, OnInit } from '@angular/core';

export interface PeriodicElement {
  subject: string;
  from: string;
  date: Date;
}

const ELEMENT_DATA: PeriodicElement[] = [
  { subject: "lorem ipsum", from: 'grtdxfewaioj@example.com', date: new Date() },
  { subject: "lorem ipsum", from: 'grtdxfewaioj@example.com', date: new Date() },
  { subject: "lorem ipsum", from: 'grtdxfewaioj@example.com', date: new Date() },
  { subject: "lorem ipsum", from: 'grtdxfewaioj@example.com', date: new Date() },
  { subject: "lorem ipsum", from: 'grtdxfewaioj@example.com', date: new Date() },
  { subject: "lorem ipsum", from: 'grtdxfewaioj@example.com', date: new Date() },
  { subject: "lorem ipsum", from: 'grtdxfewaioj@example.com', date: new Date() },
  { subject: "lorem ipsum", from: 'grtdxfewaioj@example.com', date: new Date() },
  { subject: "lorem ipsum", from: 'grtdxfewaioj@example.com', date: new Date() },
  { subject: "lorem ipsum", from: 'grtdxfewaioj@example.com', date: new Date() },
  { subject: "lorem ipsum", from: 'grtdxfewaioj@example.com', date: new Date() },
  { subject: "lorem ipsum", from: 'grtdxfewaioj@example.com', date: new Date() },
  { subject: "lorem ipsum", from: 'grtdxfewaioj@example.com', date: new Date() },
  { subject: "lorem ipsum", from: 'grtdxfewaioj@example.com', date: new Date() },
  { subject: "lorem ipsum", from: 'grtdxfewaioj@example.com', date: new Date() },
];


@Component({
  selector: 'app-foldercontent',
  templateUrl: './foldercontent.component.html',
  styleUrls: ['./foldercontent.component.scss']
})
export class FoldercontentComponent implements OnInit {

  displayedColumns: string[] = ['subject', 'from', 'date'];
  dataSource = ELEMENT_DATA;

  constructor() { }

  ngOnInit(): void {
  }

}
