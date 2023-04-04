
## Contribution
The following guidelines should be followed:
- [ ] [use conventional commit messages](https://dnb-main.github.io/deep-devxplatform-docs/ADRs/ADR-108-standard-git-commit-messages.html)
- [ ] [use independent feature branch release pattern](https://dnb-main.github.io/deep-devxplatform-docs/ADRs/ADR-109-use-git-feature-release-pattern.html)

## Definition of Done

The following statements are true when we mark a unit of work as "done":
- [ ] A Jira ticket is complete following the agile story format as documented see http://agile
- [ ] The D&B stakeholder is explicitly documented.
- [ ] The code and related tests(ex: terratest, pytest) should checked into branch related to this work
- [ ] Test coverage should be maintained at 100%
- [ ] Documentation should be updated to accurately reflect(ex: Readme, http://docs, http://adr)
- [ ] A pull request should be made to introduce the change into the "mainline" of the repository.

The pull request should include:
  - [ ] A link to the jira ticket. 
  - [ ] Automated tests results, providing a pass/fail sign-off on the change prior to being merged. 
  - [ ] Security scanning results, providing a pass/fail sign-off on the change prior to being merged. 
  - [ ] 2 Additional reviewers have reviewed and approved the change. 

Upon merge:
- [ ] The new version of the repository should be released following sematic versioning. 
- [ ] The feature was deployed and verified to be working in a live environment. 
- [ ] The use cases in the ticket's acceptance criteria has been validated. 

The Jira ticket is updated w/ proof of:
- [ ] Stakeholder acceptance(sign-off) of the change 
- [ ] Link to the relevant pull request associated with this change 
- [ ] Link to the test results 
- [ ] Link to relevant documentation 
- [ ] Link to the deployed feature in (dev/test)

## Visual representation of the development process

```mermaid
sequenceDiagram
    participant E1 as Engineer 1
    participant E2 as Engineer 2, 3, 4
    activate E1
    E1->>Jira: Story: refine, estimate & scope (whole team)
    E1->>Jira: Story: move to "In Progress"
    E1->>GitHub: Feature Branch: create
    E1->>GitHub: PR: open draft with jira number & defintion of done
    E1->>GitHub: Commits: push daily code, tests (TDD), docstrings (with detailed comments)
    E1->>GitHub: Local dev env: make test for linting & coverage, and make develop for system tests
    E1->>GitHub: PR: ensure 100% test coverage and no linting errors via GitHub Actions (GHA)
    E1->>GitHub: PR: switch to ready for review + add reviewers + test & change details 
    E1->>Jira: Story: move to "Ready for review"
    E1->>E2: Notify: team via PR channel for review
    deactivate E1
    activate E2
    E2->>GitHub: PR: review & comment
    E2->>GitHub: PR: request to resolve code changes
    deactivate E2
    loop follow the PR updates
    E1->>GitHub: PR: ensure minimum 2 reviewers approved
    activate E1
    E1->>GitHub: PR: address comments 
    E1->>GitHub: PR: make code changes
    E1->>E2: Notify: team via PR channel
    deactivate E1
    end
    activate E2
    E2->>GitHub: PR: approve & ensure GHA all green
    deactivate E2
    E1->>GitHub: PR: merge to dev
    activate E1
    E1->>nonprod: GHA: deploy changes
    E1->>nonprod: Dev: validate changes in GCP testorg, Terraform Cloud, etc. as appropriate
    E1->>Jira: Story: move to "Ready for UAT"
    deactivate E1
    E2->>nonprod: System & smoke test (inc. GCP testorg, Terraform Cloud, etc.)
    activate E2
    E2->>Jira: Story: move to "Done"
    E2->>Jira: Story: create for prod
    deactivate E2
 ```
 
*Contributor is responsible for the lifecycle of their Pull Request, which means that contributor needs to ensure that RP is getting reviewd*
*Contributor is responsible for the deployment of the change after it was merged and performing dev test prior to requesting team members to test changes*

