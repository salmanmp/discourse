import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { inject as service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import { relativeAge } from "discourse/lib/formatter";
import I18n from "I18n";

export default class PollInfoComponent extends Component {
  @service currentUser;
  @tracked min = this.args.attrs.min;
  @tracked max = this.args.attrs.max;
  @tracked options = this.args.attrs.poll.options;
  @tracked length = this.args.attrs.poll.options.length;
  @tracked poll = this.args.attrs.poll;
  @tracked post = this.args.attrs.post;
  @tracked isAutomaticallyClosed = this.args.attrs.isAutomaticallyClosed;

  get multipleHelpText() {
    const min = this.min;
    const max = this.max;
    const options = this.length;

    if (max > 0) {
      if (min === max) {
        if (min > 1) {
          return htmlSafe(
            I18n.t("poll.multiple.help.x_options", { count: min })
          );
        }
      } else if (min > 1) {
        if (max < options) {
          return htmlSafe(
            I18n.t("poll.multiple.help.between_min_and_max_options", {
              min,
              max,
            })
          );
        } else {
          return htmlSafe(
            I18n.t("poll.multiple.help.at_least_min_options", {
              count: min,
            })
          );
        }
      } else if (max <= options) {
        return htmlSafe(
          I18n.t("poll.multiple.help.up_to_max_options", { count: max })
        );
      }
    }
  }

  get votersLabel() {
    return I18n.t("poll.voters", { count: this.args.attrs.poll.voters });
  }

  get showTotalVotes() {
    return (
      this.args.attrs.isMultiple &&
      (this.args.attrs.showResults || this.args.attrs.isClosed)
    );
  }

  get totalVotes() {
    return this.poll.options.reduce((total, o) => {
      return total + parseInt(o.votes, 10);
    }, 0);
  }

  get totalVotesLabel() {
    return I18n.t("poll.total_votes", this.totalVotes);
  }

  get automaticCloseAgeLabel() {
    return I18n.t("poll.automatic_close.age", this.age);
  }

  get automaticCloseClosesInLabel() {
    return I18n.t("poll.automatic_close.closes_in", this.timeLeft);
  }

  get showMultipleHelpText() {
    return (
      this.args.attrs.isMultiple &&
      !this.args.attrs.showResults &&
      !this.args.attrs.isClosed
    );
  }

  get closeTitle() {
    const closeDate = moment.utc(this.poll.close, "YYYY-MM-DD HH:mm:ss Z");
    if (closeDate.isValid()) {
      return closeDate.format("LLL");
    } else {
      return "";
    }
  }

  get age() {
    const closeDate = moment.utc(this.poll.close, "YYYY-MM-DD HH:mm:ss Z");
    if (closeDate.isValid()) {
      return relativeAge(closeDate.toDate(), { addAgo: true });
    } else {
      return 0;
    }
  }

  get timeLeft() {
    const closeDate = moment.utc(this.poll.close, "YYYY-MM-DD HH:mm:ss Z");
    if (closeDate.isValid()) {
      return moment().to(closeDate, true);
    } else {
      return 0;
    }
  }

  get resultsOnVote() {
    return (
      this.args.attrs.poll.results === "on_vote" &&
      !this.args.attrs.hasVoted &&
      !(this.currentUser && this.post.user_id === this.currentUser.id)
    );
  }

  get resultsOnClose() {
    return (
      this.args.attrs.poll.results === "on_close" && !this.args.attrs.isClosed
    );
  }

  get resultsStaffOnly() {
    return (
      this.args.attrs.poll.results === "staff_only" &&
      !(this.currentUser && this.currentUser.staff)
    );
  }

  get publicTitle() {
    return (
      !this.args.attrs.isClosed &&
      !this.args.attrs.showResults &&
      this.args.attrs.poll.public &&
      this.args.attrs.poll.results !== "staff_only"
    );
  }

  get publicTitleLabel() {
    return htmlSafe(I18n.t("poll.public.title"));
  }
}