import { GridReadyEvent, GridSizeChangedEvent } from 'ag-grid-community';

export interface GridEvent {
  onGridReady?(params: GridReadyEvent): void;
  onGridSizeChanged(params: GridSizeChangedEvent): void;
}
