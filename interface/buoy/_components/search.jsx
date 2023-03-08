export default function ({ comp }) {
  return `
<form class="search">
  <label>
    Search:
    <input type="search" name="q">
  </label>
  ${comp.element.button({ text: "Submit" })}
</form>
`;
}
