# Peer-Review for Programming Exercise 2 #

## Description ##

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.   

## Due Date and Submission Information
See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer review. This review document should be placed into the base folder of the repo you are reviewing in the master branch. The file name should be the same as in the template: `CodeReview-Exercise2.md`. You must also include your name and email address in the `Peer-reviewer Information` section below.

If you are in a rare situation where two peer-reviewers are on a single repository, append your UC Davis user name before the extension of your review file. An example: `CodeReview-Exercise2-username.md`. Both reviewers should submit their reviews in the master branch.  

# Solution Assessment #

## Peer-reviewer Information

* *name:* Richard Shi 
* *email:* rdshi@ucdavis.edu

### Description ###

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect #### 
    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    Major flaw and some minor flaws.

#### Satisfactory ####
    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory ####
    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.


___

## Solution Assessment ##

### Stage 1 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The camera tracks the player and stays on target at all times.

___
### Stage 2 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The box correctly autoscrolls and the player is correctly constrained to the box. Correctly exports the required variables, and 

Minor gripes: the drawcamera mesh appears to be pinned to the camera somehow, so zooming in causes it to sink below the terrain, rendering it impossible to see. A similar issue is that setting one corner particularly far (eg. using -25/-25 and 5/5 as corners) causes the camera to center on the box and instead set the player off-center for some reason. Additionally, the box edge and the player's edges aren't fully synced so with weird box sizes, the player's edges peek through sometimes.

___
### Stage 3 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The camera never leaves the leash distance, and it smoothly glides back to the player. All required variables are exported properly.

Minor problem: changing catchup speed does not visibly change anything, for reasons unclear to me. Setting the three exported variables follow, catchup, and leash to 10/15/10 respectively was visually identical to 10/2000/10. On the other hand, pumping follow speed up visibly changed the behavior for all aspects, including what I understand should be the domain of catchup speed. Based on a cursory glance at the logic governing this behavior, I think this is just a programming bug, because I see a few lines that should in theory be logically correct. Not a huge issue, just needed a bit more testing before deployment.

___
### Stage 4 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Variables exported correctly. Camera delay works. Camera drifts back smoothly. I did rather like the quaint little line indicator that showed player velocity direction. I had some issues with the default settings since the original leadspeed appeared visually indistinguishable from the previous camera. 

Hilarious observation: catchup speed didn't work in stage 3 but works perfectly here. 

___
### Stage 5 ###

- [ ] Perfect
- [ ] Great
- [x] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Variables were exported correctly. 

The behavior is a little janky. If my testing is correct, it appears that the box was drawn on the inner speedup zone rather than the outer one. Mildly confusing. Additionally, the initial pushratio given was 1.5, which caused the illusion of total dysfunction (this is my second rewriting of feedback after repeated testing! please make your default values actually usable!!! and to whoever reads this prior to grading, PLEASE FIDDLE WITH THE VARIABLES BEFORE GRADING). 

When moving in diagonals, the box does weird stuff and sometimes sticks. The expected behavior is for the players movement in the x and z axes to be independent, but in this implementation, moving all the way left until touching the outer box and then moving up causes the entire box the shift upwards. The camera will not produce the accelerating effect until the left key is released. 

Additionally, the camera incorrectly moves when the vessel is moving backwards in the speedup zone.
___
# Code Style #


### Description ###
Check the scripts to see if the student code adheres to the dotnet style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.


#### Style Guide Infractions ####

The style guide says to prefer the plain English version of boolean operators, so I think the negations in [this](https://github.com/ensemble-ai/exercise-2-camera-control-isabelshic/blob/495d61221099f992ac1fb87aa41268ff31b69c4a/Obscura/scripts/camera_controllers/camera_controller_pushzone.gd#L18) line could probably be rewritten using "not"

Frankly there weren't a lot of infractions as far as I can tell. 

#### Style Guide Exemplars ####

[This](https://github.com/ensemble-ai/exercise-2-camera-control-isabelshic/blob/495d61221099f992ac1fb87aa41268ff31b69c4a/Obscura/scripts/camera_controllers/camera_controller_leadinglerp.gd#L26) is a great example of wrapping a super long line. 

Throughout all the scripts, this person did a pretty deliberate job of controlling line length. Many complicated calculations are broken up to be more visually comprehensible. 

Variables, functions, classes, etc. pretty much all follow naming conventions.

___
#### Put style guide infractures ####

___

# Best Practices #

### Description ###

If the student has followed best practices (Unity coding conventions from the StyleGuides document) then feel free to point at these code segments as examplars. 

If the student has breached the best practices and has done something that should be noted, please add the infraction.


This should be similar to the Code Style justification.

#### Best Practices Infractions ####

The script attached to the position locked camera has a strange name. The class is correctly named PositionLock, but the file itself is called push_box.gd, which is very confusing. 

I feel like [this](https://github.com/ensemble-ai/exercise-2-camera-control-isabelshic/blob/495d61221099f992ac1fb87aa41268ff31b69c4a/Obscura/scripts/camera_controllers/camera_controller_pushzone.gd#L34) chunk of nested if-statements could be simplified for more clarity

Some of the default values in the project (the version I cloned at least) caused strange behavior.

Only one commit. Probably not the best use of a version control system.

Some more documentation might be nice. The logic of the more complicated calculations take a moment to parse.

#### Best Practices Exemplars ####

Did a great job of keeping things clear and readable.

Variable names were mostly helpful and meaningful.

Good use of [helper functions](https://github.com/ensemble-ai/exercise-2-camera-control-isabelshic/blob/495d61221099f992ac1fb87aa41268ff31b69c4a/Obscura/scripts/camera_controllers/camera_controller_pushzone.gd#L61) to handle gnarly computations and clarify the logic of the code.