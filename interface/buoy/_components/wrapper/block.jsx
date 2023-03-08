export const css = `
.block {
  padding: 8px;
  margin: 10px 4px 4px 4px;
  border: 1px solid #40628a;
  background-color: #202020;
}

.block h3 {
  padding: 0;
}
`;

export default ({ content }) => `<div class="block">${content}</div>`;
