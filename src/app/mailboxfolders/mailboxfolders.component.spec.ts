import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MailboxfoldersComponent } from './mailboxfolders.component';

describe('MailboxfoldersComponent', () => {
  let component: MailboxfoldersComponent;
  let fixture: ComponentFixture<MailboxfoldersComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ MailboxfoldersComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(MailboxfoldersComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
