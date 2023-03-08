import * as ui_title from "./ui_title.jsx";
import * as ui_content from "./ui_content.jsx";

export const css = `
body {
	padding: 0;
	margin: 0;
	background-color: #272727;
	font-size: 12px;
	color: #ffffff;
	line-height: 170%;
	cursor: default;
	user-select: none;
	-moz-user-select: none;
	-ms-user-select: none;
}
`;

export default ({ title, content }) =>
`<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>${title}</title>
		<link rel="stylesheet" href="components.css" />
	</head>
	<body>
		${ui_title({ title })}
		${ui_content({ content })}
	</body>
</html>`;
