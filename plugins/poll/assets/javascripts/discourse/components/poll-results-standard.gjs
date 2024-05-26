import Component from "@glimmer/component";
import evenRound from "discourse/plugins/poll/lib/even-round";
import PollVoters from "./poll-voters";
import { htmlSafe } from "@ember/template";
import { concat } from "@ember/helper";

export default class PollResultsStandardComponent extends Component {
  get votersCount() {
    return this.args.votersCount || 0;
  }

  get orderedOptions() {
    const votersCount = this.votersCount;

    let ordered = [...this.args.options].sort((a, b) => {
      if (a.votes < b.votes) {
        return 1;
      } else if (a.votes === b.votes) {
        if (a.html < b.html) {
          return -1;
        } else {
          return 1;
        }
      } else {
        return -1;
      }
    });

    const percentages =
      votersCount === 0
        ? Array(ordered.length).fill(0)
        : ordered.map((o) => (100 * o.votes) / votersCount);

    const rounded = this.isMultiple
      ? percentages.map(Math.floor)
      : evenRound(percentages);

    ordered.forEach((option, idx) => {
      const per = rounded[idx].toString();
      const chosen = (this.args.vote || []).includes(option.id);
      option.percentage = per;
      option.chosen = chosen;
      let voters = this.args.voters[option.id] || [];
      option.voters = [...voters];
    });

    return ordered;
  }

  get isMultiple() {
    return this.args.pollType === "multiple";
  }
  <template>
    <ul class="results">
      {{#each this.orderedOptions key="voters" as |option|}}
        <li class={{if option.chosen "chosen" ""}}>
          <div class="option">
            <p>
              {{#unless @isIrv}}
                <span class="percentage">{{option.percentage}}%</span>
              {{/unless}}
              <span class="option-text">{{option.html}}</span>
            </p>
            {{#unless @isIrv}}
              <div class="bar-back">
                <div
                  class="bar"
                  style={{htmlSafe (concat "width:" option.percentage "%")}}
                />
              </div>
            {{/unless}}
            <PollVoters
              @postId={{@postId}}
              @pollType={{@pollType}}
              @optionId={{option.id}}
              @pollName={{@pollName}}
              @isIrv={{@isIrv}}
              @totalVotes={{option.votes}}
              @voters={{option.voters}}
              @fetchVoters={{@fetchVoters}}
              @loading={{option.loading}}
            />
          </div>
        </li>
      {{/each}}
    </ul>
  </template>
}