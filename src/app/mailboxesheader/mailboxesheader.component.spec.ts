import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MailboxesheaderComponent } from './mailboxesheader.component';

describe('MailboxesheaderComponent', () => {
  let component: MailboxesheaderComponent;
  let fixture: ComponentFixture<MailboxesheaderComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ MailboxesheaderComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(MailboxesheaderComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
