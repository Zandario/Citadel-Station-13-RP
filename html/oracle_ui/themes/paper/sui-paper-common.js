export function replaceContent(body) {
	const maincontent = document.getElementById("maincontent");
	if (maincontent) {
		maincontent.innerHTML = body;
	}
}

function updateProgressLabels() {
	const progressBars = document.getElementsByClassName("progressBar");
	for (let i = 0; i < progressBars.length; i++) {
		const progressBar = progressBars[i];
		if (!progressBar) continue;
		const progressFill =
			progressBar.getElementsByClassName("progressFill")[0];
		if (!progressFill) continue;
		const width = parseInt(getComputedStyle(progressFill).width);
		const maxWidth = parseInt(getComputedStyle(progressBar).width);
		const progressLabel =
			progressBar.getElementsByClassName("progressLabel")[0];
		if (progressLabel)
			progressLabel.innerHTML =
				Math.round((width / maxWidth) * 100) + "%";
	}
}

if (getComputedStyle) {
	setInterval(updateProgressLabels, 50);
} //Fallback

export function updateFields(json) {
	const fields = JSON.parse(json);
	for (const key in fields) {
		const value = fields[key];
		const element = document.getElementById(key);
		if (element == null) {
			continue;
		} else if (element.classList.contains("progressBar")) {
			const progressFill =
				element.getElementsByClassName("progressFill")[0];
			if (progressFill) progressFill.style["width"] = value;
			if (!getComputedStyle) {
				//Fallback
				const progressLabel =
					element.getElementsByClassName("progressLabel")[0];
				if (progressLabel) progressLabel.innerHTML = value;
			}
		} else {
			element.innerHTML = value;
		}
	}
}
