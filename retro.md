# Sprint retrospective notes

## Sprint 1

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

## Sprint 2

The second retrospective was held right after the customer meeting, fortunately face-to-face this time. The Glad, Sad, Mad icebreaker was used again. Things that were brought up were:

**Glad:**
- Successfully completed the user stories that were the minimum goal for the sprint.
- Good transparency among the team. In the last retrospective we were able to speak openly about things that bothered us.
- Work was divided more evenly this time.
- Unit tests were handled well.
- Having someone in charge of important things was a good idea.

**Sad:**
- Found bugs that our Robot tests didn't catch so we will need to fix them in the next sprint.
- It turned out that one story (BibTeX) required quite a bit more tasks than we anticipated. We got everything done but it would have been cleaner to split it up.

**Mad:**
- The sprint was 1 day shorter.
- Our top priority stories had conflicting criteria and there was no information on the course page about whether the use of JavaScript was allowed, so we couldn't really get started before clearing those things up.
- There was an issue where the Robot tests didn't pass in the CI pipeline sometimes even though they passed locally. We found a temporary fix by making the robot retry the tests a few times, but we suspected it might be because the CI pipeline runs them in headless mode so we have yet to find a solution to that.

**Measures for improvement:**
- Meet up to work on the project together at least once.
- Utilize branches more. Merge branches in the browser (instead of the CLI) so that the changes will go through the CI pipeline first.
- Assigned one more person to check that the grading criteria for each sprint are met.

Overall the team felt accomplished with the last sprint and there wasn't much that we were sad about. We felt that after two sprints we had gotten better at estimating the time and workload of a given task. We now also have a better idea of how to decide who works on which user stories so that we can work efficiently and avoid overlaps. After the retrospective we decided on a time for the group dev session.