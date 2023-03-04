"use strict";

function replaceContent(body) {
	let maincontent = document.getElementById("maincontent");
	if (maincontent) {
		maincontent.innerHTML = body;
	}
}

function updateProgressLabels() {
	let progressBars = document.getElementsByClassName("progressBar");
	for (let i = 0; i < progressBars.length; i++) {
		let progressBar = progressBars[i];
		if (!progressBar) {
			continue;
		}
		let progressFill =
			progressBar.getElementsByClassName("progressFill")[0];
		if (!progressFill) {
			continue;
		}
		let width = parseInt(getComputedStyle(progressFill).width);
		let maxWidth = parseInt(getComputedStyle(progressBar).width);
		let progressLabel =
			progressBar.getElementsByClassName("progressLabel")[0];
		if (progressLabel) {
			progressLabel.innerHTML =
				Math.round((width / maxWidth) * 100) + "%";
		}
	}
}

if (getComputedStyle) {
	setInterval(updateProgressLabels, 50);
} // Fallback

function updateFields(json) {
	let fields = JSON.parse(json);
	for (let key in fields) {
		let value = fields[key];
		let element = document.getElementById(key);
		if (element == null) {
			continue;
		} else if (element.classList.contains("progressBar")) {
			let progressFill =
				element.getElementsByClassName("progressFill")[0];
			if (progressFill) {
				progressFill.style["width"] = value;
			}
			if (!getComputedStyle) {
				// Fallback
				let progressLabel =
					element.getElementsByClassName("progressLabel")[0];
				if (progressLabel) {
					progressLabel.innerHTML = value;
				}
			}
		} else {
			element.innerHTML = value;
		}
	}
}
