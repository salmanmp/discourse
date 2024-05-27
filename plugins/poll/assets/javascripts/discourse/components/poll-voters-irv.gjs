import Component from "@glimmer/component";
import { eq } from "truth-helpers";
import avatar from "discourse/helpers/bound-avatar-template";
import icon from "discourse-common/helpers/d-icon";

export default class PollVotersComponent extends Component {
  groupVotersByRank = (voters) => {
    return voters.reduce((groups, voter) => {
      const rank = voter.rank;
      if (!groups[rank]) {
        groups[rank] = [];
      }
      groups[rank].push(voter);
      return groups;
    }, {});
  };

  get irvVoters() {
    const voters = [...this.args.voters];

    // Group voters by rank so they can be displayed together by rank
    const groupedByRank = this.groupVotersByRank(voters);

    // Convert groups to array of objects with keys rank and voters
    const groupedVoters = Object.keys(groupedByRank).map((rank) => ({
      rank,
      voters: groupedByRank[rank],
    }));

    return groupedVoters;
  }

  <template>
    {{#each this.irvVoters as |rank|}}
      <ul>
        {{#if (eq rank.rank "Abstain")}}
          <span class="rank">{{icon "ban"}}</span>
        {{else}}
          <span class="rank">{{rank.rank}}</span>
        {{/if}}
        {{#each rank.voters as |user|}}
          <li>
            {{avatar user.user.avatar_template "tiny"}}
          </li>
        {{/each}}
      </ul>
    {{/each}}
  </template>
}
