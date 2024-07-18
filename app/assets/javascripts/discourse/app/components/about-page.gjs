import Component from "@glimmer/component";
import { service } from "@ember/service";
import i18n from "discourse-common/helpers/i18n";
import { htmlSafe } from "@ember/template";
import PluginOutlet from "discourse/components/plugin-outlet";
import { hash } from "@ember/helper";
import dIcon from "discourse-common/helpers/d-icon";

export default class AboutPage extends Component {
  <template>
    <section class="about__header">
      <img src={{@model.banner_image}} />
      <h2>{{@model.title}}</h2>
      <p>{{@model.description}}</p>
      <PluginOutlet
        @name="about-after-description"
        @connectorTagName="section"
        @outletArgs={{hash model=this.model}}
      />
    </section>
    <div class="about__main-content">
      <section class="about__left-side">
        <div class="about__stats">
          <ul>
            <li>
              {{dIcon "users"}}
            </li>
          </ul>
        </div>
      </section>
      <section class="about__right-side">
      </section>
    </div>
    <div>{{htmlSafe @model.extended_site_description}}</div>
  </template>
}
