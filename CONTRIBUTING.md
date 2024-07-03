# Contribution Guide

Follow these steps to contribute using pull requests (PR) with merge commits and track your work with Jira issue keys.

## Making Changes

### 1. Create a Feature Branch
1. Create a new branch, optionally including the Jira issue key (you can find the Jira issue key on the board page at the bottom of each card) in the branch name:
   ```
   git checkout -b JIRA-123-feature-branch
   ```

### 2. Make Changes and Commit
1. Make your changes.
2. Stage the changes:
   ```
   git add .
   ```
3. Commit the changes, including the Jira issue key in the commit message:
   ```
   git commit -m "JIRA-123: Describe your changes"
   ```

### 3. Push Your Changes
```
git push origin JIRA-123-feature-branch
```

## Submitting a Pull Request

### 4. Create a Pull Request
1. Go to the repository on GitHub.
2. Click on **Compare & pull request**.
3. Select the base repository and branch, provide a title and description including the Jira issue key, then click **Create pull request**.

## Starting a New Feature

### 5. After Merging PR
1. Fetch and merge the latest changes from the main branch:
   ```
   git checkout main
   git pull upstream main
   ```

2. Create a new branch for the next feature, optionally including the Jira issue key:
   ```
   git checkout -b JIRA-456-new-feature-branch
   ```

### Tracking Progress with Jira

1. Include the Jira issue key in commit messages, branch names, and PR titles to link your work to the user stories and tasks on the Jira Scrum board.
2. Update the issue status on Jira as you progress with your work.
