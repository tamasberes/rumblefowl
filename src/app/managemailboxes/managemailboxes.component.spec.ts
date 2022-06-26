import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ManagemailboxesComponent } from './managemailboxes.component';

describe('ManagemailboxesComponent', () => {
  let component: ManagemailboxesComponent;
  let fixture: ComponentFixture<ManagemailboxesComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ManagemailboxesComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ManagemailboxesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
