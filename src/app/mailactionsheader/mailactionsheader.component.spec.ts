import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MailactionsheaderComponent } from './mailactionsheader.component';

describe('MailactionsheaderComponent', () => {
  let component: MailactionsheaderComponent;
  let fixture: ComponentFixture<MailactionsheaderComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ MailactionsheaderComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(MailactionsheaderComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
