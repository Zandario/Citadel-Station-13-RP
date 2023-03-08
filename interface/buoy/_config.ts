import lume from "lume/mod.ts";
import minifyHTML from "lume/plugins/minify_html.ts";
import { Options } from "lume/plugins/minify_html.ts";
import jsx from "lume/plugins/jsx.ts";
import sass from "lume/plugins/sass.ts";

const site = lume();

const minifyOptions: Options = {
  extensions: [".html", ".css", ".js"],
  options: {
    do_not_minify_doctype: true,
    ensure_spec_compliant_unquoted_attribute_values: true,
    keep_closing_tags: false,
    keep_html_and_head_opening_tags: false,
    keep_spaces_between_attributes: false,
    keep_comments: false,
    minify_js: true,
    minify_css: true,
    remove_bangs: false,
    remove_processing_instructions: false,
  },
};

// Lume plugins
site.use(jsx());
site.use(sass());
site.use(minifyHTML(minifyOptions));

export default site;
