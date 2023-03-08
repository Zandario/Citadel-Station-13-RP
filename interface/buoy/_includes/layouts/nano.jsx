export default function ({ comp, content, title }) {
  return `<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>${title}</title>
		<link rel="stylesheet" href="components.css" />
		<link rel="stylesheet" href="/assets/nano.css" />
	</head>
	<body>
		${comp.wrapper.ui_title({ title })}
		${comp.wrapper.ui_content({ content })}
	</body>
</html>`;
}
