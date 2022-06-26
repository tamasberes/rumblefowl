import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FoldercontentComponent } from './foldercontent.component';

describe('FoldercontentComponent', () => {
  let component: FoldercontentComponent;
  let fixture: ComponentFixture<FoldercontentComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ FoldercontentComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(FoldercontentComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
