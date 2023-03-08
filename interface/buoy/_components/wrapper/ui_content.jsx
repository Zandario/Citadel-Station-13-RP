export const css = `
.uiWrapper {
	width: 100%;
	height: 100%;
}
`;

export default function ({ content }) {
  return `<div class="uiWrapper">${ content }</div>`;
}
