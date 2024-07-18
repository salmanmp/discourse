import Controller from "@ember/controller";
import { alias, gt } from "@ember/object/computed";
import discourseComputed from "discourse-common/utils/decorators";
import I18n from "discourse-i18n";

export default Controller.extend({
  faqOverridden: gt("siteSettings.faq_url.length", 0),
  renameFaqToGuidelines: alias(
    "siteSettings.experimental_rename_faq_to_guidelines"
  ),

  @discourseComputed("siteSettings.experimental_redesigned_about_page_groups")
  displayV2Design(groups) {
    const allowedGroupIds = groups.split("|").map((id) => parseInt(id, 10));
    return this.currentUser.groups.any((group) =>
      allowedGroupIds.includes(group.id)
    );
  },

  @discourseComputed("model.contact_url", "model.contact_email")
  contactInfo(url, email) {
    if (url) {
      return I18n.t("about.contact_info", {
        contact_info: `<a href='${url}' target='_blank'>${url}</a>`,
      });
    } else if (email) {
      return I18n.t("about.contact_info", {
        contact_info: email,
      });
    } else {
      return null;
    }
  },
});
