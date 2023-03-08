import type { Page, PageData } from "lume/core.ts";

// To handle all types in one place, use re-export
export type { PageHelpers } from "lume/core.ts";

// Example interface for `custom.tsx` PageData
export interface CustomPageData extends PageData {
  // Define your own properties
  readingTime?: string;
}

// Create a new interface for `custom.tsx`
export interface CustomPage extends Page {
  data: CustomPageData;
}
