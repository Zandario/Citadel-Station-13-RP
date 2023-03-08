export const css = `
.uiTitle {
	clear: both;
	padding: 6px 8px 6px 8px;
	border-bottom: 2px solid #161616;
	background: #383838;
	color: #98b0c3;
	font-size: 16px;
}
`;

export default function ({ title }) {
  return `<div class="uiTitle">${title}</div>`;
}
