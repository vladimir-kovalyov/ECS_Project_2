# Infrastructure WorkStream Project - Host your simple website

The objective of this project is to work in pairs and provision cloud infrastructure to host your blog website

## Project requirements:

1. You have until Friday at 2:30PM to complete your project.

2. Create a Kanban board in JIRA to track your work. Each feature should be documented in this Kanban board, with a story point estimate and simple acceptance criteria. 

3. At the end of the project you will need to present:
    - Provide a summary of your overall solution
    - How many story points you estimated you could complete within the project timeline
    - How many story points you actually achieved
    - Present a live demo of your hosted blog site
    - Lessons learnt both individually and in running a project

## Application Requirements:

1. Containerise your blog website using docker. Create a registry in AWS using ECR and appropriately tag your images.

2. Automated the building and publication to the registry of your container image, whenever a commit to the git repository is made. Depending on which branch is committed to, you may wish to tag your container images differently.

3. Design simple cloud infrastructure using AWS, to run your containerised application. Build a diagram using draw.io to show what you intend to build.

4. Using Terraform, build the cloud infrastructure you have designed. 


## Stretch Goals

1. Introduce autoscaling and demonstrate this working by using a performance testing tool such as Apache Bench or JMeter.

2. Create two versions of your infrastructure, a development environment and a production environment.