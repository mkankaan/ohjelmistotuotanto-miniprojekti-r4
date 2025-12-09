# Sprint retrospective notes

### Go to:
- [Sprint 1](#sprint1)
- [Sprint 2](#sprint2)
- [Sprint 3](#sprint3)

## <a name="sprint1"></a> Sprint 1

The first sprint retrospective was held in the evening after the customer meeting and demo. The retrospective was held over Discord due to time constraints, although the team agreed that meeting face-to-face would be preferable. The Glad, Sad, Mad icebreaker was used. Points that were raised were:

**Glad:**
- All user stories were completed successfully.
- Communication was active on Discord.

**Sad:**
- The team agreed that there wasn’t enough to do for everyone. Many tasks, such as things to do with configuration, were dependent of eachother, making it difficult to divide tasks evenly and give everyone a chance to contribute.
- Some tasks should have been written more clearly.
- The team relied too heavily on someone to be the leader and other members should have taken more initiative.
- The team agreed that meeting face-to-face would boost productivity, communication and the quality of the product, but this would be challenging due to some team members having long commutes. Pair programming was also suggested.
- Unpreparedness for the customer meeting.

**Mad:**
- There was some confusion over whether a certain task had been started or not because the product backlog didn’t have a ”Not started” state.

**Measures for improvement (kehitystoimenpide):**
- Let’s aim to work together more, face-to-face or in a Discord call.
- Let’s define tasks more clearly and make sure they’re more independent of eachother.
- Everyone gets their own user story to work on for starters.

As a result of the retrospective a team member was assigned to be in charge of each
- Tests (Robot and unit) and coverage
- Layout
- Product and sprint backlogs
- README file

Although multiple people would be working on e.g. tests and backlogs, these roles were assigned to ensure that everything gets done and everything is properly maintained. The retrospective also gave us a better idea of how to improve working as a team.

## <a name="sprint2"></a> Sprint 2

The second retrospective was held right after the customer meeting, fortunately face-to-face this time. The Glad, Sad, Mad icebreaker was used again. Things that were brought up were:

**Glad:**
- Successfully completed the user stories that were the minimum goal for the sprint.
- Good transparency among the team. In the last retrospective we were able to speak openly about things that bothered us.
- Work was divided more evenly this time.
- Unit tests were handled well.
- Having someone in charge of important things (backlogs etc.) was a good idea.

**Sad:**
- Found bugs that our Robot tests didn't catch so we will need to fix them in the next sprint.
- It turned out that one story (BibTeX) required quite a bit more tasks than we anticipated. We got everything done but it would have been cleaner to split it up.

**Mad:**
- The sprint was 1 day shorter.
- Our top priority stories had conflicting criteria and there was no information on the course page about whether the use of JavaScript was allowed, so we couldn't really get started before clearing those things up.
- There was an issue where the Robot tests didn't pass in the CI pipeline sometimes even though they passed locally. We found a temporary fix by making the robot retry the tests a few times, but we suspected it might be because the CI pipeline runs them in headless mode so we have yet to find a solution to that.

**Measures for improvement:**
- Meet up to work on the project together at least once.
- Utilize branches more. Merge branches with a pull request (instead of the CLI) so that the changes will go through the CI pipeline first.
- Assigned one more person to check that the grading criteria for each sprint are met.

Overall the team felt accomplished with the last sprint and there wasn't much that we were sad about. We felt that after two sprints we had gotten better at estimating the time and workload of a given task. We now also have a better idea of how to decide who works on which user stories so that we can work efficiently and avoid overlaps. After the retrospective we decided on a time for the group dev session.

## <a name="sprint3"></a> Sprint 3

The third sprint retrospective was held right after the customer meeting, using Glad, Sad, Mad again. Things that were brought up this time were:

**Glad:**
- Completed (almost) all user stories (with the exception of a few missing tests).
- As a team we have gotten progressively more proactive in the requirements specification with the customer and know what questions to ask to make sure we're all on the same page.
- Pair programming was a good idea and we got a few bugs fixed.

**Sad:**
- Test coverage dipped below 80% for a while.
- Some of our top priority stories were left to the very end of the sprint because we had to reassign them to a different person than originally planned. (For example, person A was going to do stories #2 and #3, but only had time to do one of them). We had originally divided the stories in a way where we thought everyone could work on an isolated area of the project without having to wait for someone else to finish another feature first, but it turns out that this could have been planned better. Moreover, coordinating priorities in a team in such a small-scale project is difficult, given that sprints are only a week long and some features will inevitably depend on eachother. We figured that in a larger-scale project this would probably be less of an issue.

**Mad:**
- Other courses take away time from working on the project.
- Computer got damaged, had trouble running the project on a borrowed computer.

**Measures for improvement:**
- Everyone makes sure to maintain test coverage at a sufficient level for their own part.
- At least the top 5 priority stories are given to different people to make sure everything gets done.
