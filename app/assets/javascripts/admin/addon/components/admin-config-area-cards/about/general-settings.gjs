import Component from "@glimmer/component";
import { fn } from "@ember/helper";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import DEditor from "discourse/components/d-editor";
import UppyImageUploader from "discourse/components/uppy-image-uploader";
import withEventValue from "discourse/helpers/with-event-value";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";
import i18n from "discourse-common/helpers/i18n";
import I18n from "discourse-i18n";
import Form from "discourse/components/form";
import { cached } from "@glimmer/tracking";

export default class AdminConfigAreasAboutGeneralSettings extends Component {
  @service toasts;

  name = this.args.generalSettings.title.value;
  summary = this.args.generalSettings.siteDescription.value;
  extendedDescription = this.args.generalSettings.extendedSiteDescription.value;
  aboutBannerImage = this.args.generalSettings.aboutBannerImage.value;

  @cached
  get data() {
    return {
      name: this.args.generalSettings.title.value,
      summary: this.args.generalSettings.siteDescription.value,
      extendedDescription:
        this.args.generalSettings.extendedSiteDescription.value,
      aboutBannerImage: this.args.generalSettings.aboutBannerImage.value,
    };
  }

  @action
  async save(data) {
    try {
      this.args.setGlobalSavingStatus(true);
      console.log(data);
      await ajax("/admin/config/about.json", {
        type: "PUT",
        data: {
          general_settings: {
            name: data.name,
            summary: data.summary,
            extended_description: data.extendedDescription,
            about_banner_image: data.aboutBannerImage,
          },
        },
      });
      this.toasts.success({
        duration: 3000,
        data: {
          message: I18n.t(
            "admin.config_areas.about.toasts.general_settings_saved"
          ),
        },
      });
    } catch (err) {
      popupAjaxError(err);
    } finally {
      this.args.setGlobalSavingStatus(false);
    }
  }

  @action
  setImage(upload, { set }) {
    set("aboutBannerImage", upload.url);
  }

  <template>
    <Form @data={{this.data}} @onSubmit={{this.save}} as |form|>
      <form.Field
        @name="name"
        @title={{i18n "admin.config_areas.about.community_name"}}
        @validation="required"
        as |field|
      >
        <field.Input />
      </form.Field>

      <form.Field
        @name="summary"
        @title={{i18n "admin.config_areas.about.community_summary"}}
        @format="large"
        as |field|
      >
        <field.Input />
      </form.Field>

      <form.Field
        @name="extendedDescription"
        @title={{i18n "admin.config_areas.about.community_description"}}
        as |field|
      >
        <field.Composer />
      </form.Field>

      <form.Field
        @name="aboutBannerImage"
        @title={{i18n "admin.config_areas.about.banner_image"}}
        @subtitle={{i18n "admin.config_areas.about.banner_image_help"}}
        @onSet={{this.setImage}}
        as |field|
      >
        <field.Image />
      </form.Field>

      <form.Submit />
    </Form>
  </template>
}
