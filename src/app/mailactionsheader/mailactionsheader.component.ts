import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ManagemailboxesComponent } from '../managemailboxes/managemailboxes.component';

@Component({
  selector: 'app-mailactionsheader',
  templateUrl: './mailactionsheader.component.html',
  styleUrls: ['./mailactionsheader.component.scss']
})
export class MailactionsheaderComponent implements OnInit {

  constructor(public dialog: MatDialog) { }

  ngOnInit(): void {
    this.onManageMailboxesClicked()
  }

  onManageMailboxesClicked() {
    const dialogRef = this.dialog.open(ManagemailboxesComponent);

    dialogRef.afterClosed().subscribe(result => {
      console.log(`Dialog result: ${result}`);
    });
  }

}
