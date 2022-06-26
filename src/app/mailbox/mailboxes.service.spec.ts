import { TestBed } from '@angular/core/testing';

import { MailboxesService } from './mailboxes.service';

describe('MailboxesService', () => {
  let service: MailboxesService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(MailboxesService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
