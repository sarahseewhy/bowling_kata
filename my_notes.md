**Break down the Game**

There is this thing 'Game'

It has 10 frames with 2 rolls per frame for a total of 20 rolls for every 'Game'.

Each roll can hit anywhere from 0 to 10 pins.

Each pin hit scores one point (with a few exceptions)

Scoring scenarios for 20 rolls:
	1) Players start with a score of 0
	2) Gutter game: hit 0 pins every 20 rolls => score result: 0
	3) Normal Points: hit 1 pin every 20 rolls => score result: 20
	4) Spare: hit a total of 10 pins in a frame, add the result of first roll of the second frame as a bonus  => score result: Frame1, Roll1 == 5, Frame1 Roll2 == 5, Frame2, Roll1 == 5: F1 == 15
	5) Strike: hit 10 pins in F1R1, add the points from the next 2 rolls => F1R1 == 10, F2R1 == 3, F2R2 == 3, F1 total score is 10 + (3+3), or 16. F2 score is 6

**Break down parts of the game**

What is 'Game' => need to instantiate game...but with what?

If I'm going to use roll(pins) as a 'scoreboard' (something that stores rolls & points), then the Game should begin with a blank score board indicating no points.

**What is 'rolls'**
It's a record of how many rolls have been made and the corresponding points. 

We could make it an array of a total of 20 elements, each element symbolizes a roll and the value of each element as a score - how to get the score?

Basically what I want to create is the code equivalent of the score board that stores the important information about Game (rolls, points, and potentially frame information).

I want to be able to access this information throughout the Game.

**How to add data to rolls?**

We need to add data to the empty @rolls array (scoreboard).

In the game, data is passed to the scoreboard after someone makes a roll and hits pin(s).

So the action roll is connected to how many pins are hit

We could make a method roll take an argument (pins_hit) and then push (pins_hit) into the array.

How to test for this? Hmm. Well if we create the given scoring scenarios that should test if the roll(pins_hit) method works. 

We're testing that in a given Game, which is a total of 20 rolls, if 0 pins are hit the score will be 0.

Sidenote: I'm going to have to figure out whether I need frames at some point.

Got into a testing stuck place: I can create an array indicating rolls and corresponding points, but the expectation wants a total number, not a series of elements in an array. I guess I have to look up a method that adds elements of an array together.

**Dealing with spares**
How to test this?

	Say I'm playing the game from the beginning.
		1) I start with an empty scoreboard
		2) In F1R1 I roll and score 3 points
		3) In F1R2 I roll and score 7 points (for a total of 10)
		4) In F2R1 I roll a 3. This is added to my F1 score for a total of 13
		5) To make things easy let's say for the rest of the game (17 rolls left) I roll gutter balls (0)
		6) My F1 score is 13 and my F2 score is 3 for a total Game score of 16

Ok, the test is saying it expect the score to be 16 but it actually got 13 which indicates that my method for adding the total score needs to be revised.

**Dealing with total score**

At the moment this is what my 'scoreboard' looks like this
[3, 7, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

It calculates the total score by adding 3 + 7 + 3 + (0 * 17).

What I want it to do is add the first two elements of the array, add the third element to that sum, and then add the third and fourth element to get a separat sum. 

It could look something like this:
[[3, 7],[3, 0],[0, 0]..etc] where I add sub-elements of each element (each sub element is a frame).

Or this
{[3,7], [3,0], [0,0]} where I do something similar.

But both of those look a little complicated.

So let's start again. 
[3, 7, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

What I want to do is:

(3 + 7 + 3) + (3) + 0..0

element = e

(e0 + e1 + e2) + e3..e19

BUT only when e0 + e1 == 10

So if e0 + e1 == 10 add e3 and then add the rest, else add everything together.

The above explanation uses position of the elements in the array, or the element index, to figure out which elements to add and when. 

If the sum of e0..e1 == 10, add e2 to the sum of e0 + e1, then iterate over e2..e19 and calculate the total.

Right, I've just tried this and it makes the test pass but both the test and the code assumes my F1 will score a spare, it doesn't look for spares throughout the 20 rolls or 10 frames.

I suppose this indicates that I need to somehow iterate over all the rolls/frames to see if two consecutive elements add to 10. But even that's a bit vague because [3, 7, 3] would be 10 if you count e0 + e1 or e1 + e2. Let me do some googling, what are some adding/sum options in Ruby?

sum, +, +=. 
+=  means c = c + a or, c += a will assigne value of c + a to c

In practice does that means that 5 += 2 is 7 (i.e., 5 + 2) or 12 (i.e., 5 + (5+2)), because if it's the latter then I think that might fit. 

Basically I'm struggling to revise and nuance the .inject method so I have a bit more control over what it's adding. I think I'll need to abandon it for something a bit more hands-on. So lets go back to what total_socre is and what it does.

Total score is a reflection of how many points have been scored (pins hit) in 20 rolls.

Total score consecutively adds each element of the array. 

Can I break that down any further? 

Total score result starts at 0. For 20 elements in an array, add each element to the previous one and then add that to the result. Return the result.

If I do this I get an error "Array can't be coerced into a Fixnum". This tells me I'm trying to do something in Ruby that Ruby just can't do. 

I'm trying to add an array to the value 0 and that doesn't seem right.

But I don't want to add an array to zero, I want to add the elements in the array. What happens if I create a standin array element (array_element), set it to 0 because array indices start at 0. 

If I use that as a standin index for @scoreboard[array_element], what does that do? Ok...it works. But I'm not sure how or why. 

Maybe if I take it line by line. 

def total_score 

result = 0 --> setting result to 0. Result will be what I want to return at the end

array_element = 0 --> creating a standin array index and setting it to 0

20.times do --> for 20 iterations/times do the following

result += @scoreboard[array_element] --> is the same as result + @scoreboard[array_element]

Where result is 0 and @scoreboard is an array and array_element is 0, or the first element in the array.

So result + @scoreboard[array_element] is the same as saying 0 + @scoreboard[0]

Now, @scoreboard starts as 0 but in the test we've given it some instructions. If the game has just started or I roll a gutter ball (so @scoreboard is an array [0]) then it should read 0 + @scoreboard[array_element] which is really saying:

0 + the first element in the array @scoreboard (or in this case 0) == 0

If on my first roll I hit 3 pins (3 points) it should read:

0 + the first element in the array @scoreboard (in this case 3)
== 3

array_element += 1 --> increments the array_element by 1 so that when the computer runs through the block a second time it should read something like this:

result (which is 3 because I scored 3 points in my first roll) +
@scoreboard[array_element] (where array_element is now 1, or the second element in the array which in my test is 7)

so the result == 10

This is repeated 20 times (over the entire array) 

I get it. 

My Spare test is still failing but I think I can fix that. 

**Spare Test**

The total_score method iterates over every roll (20 rolls), but bowling is divided into frames (10 frames). 

To mimic how scoring actually works I would need to add an array_element to the following array_element (so array_element + 1) and then increment until I get to element index 2 or third element.

I want to start the process on every second element so I should increment by 2. 

Hmm, test fails. 

Ah! I still need to add the score from F2R1 and this should be a conditional statement. It's only if the two elements equal 10. 

Tests pass.

**Refactoring**

The total_score method looks a bit complex and I think I can separate out the spare situation, spare score method, and normal score method.

**Strike Test**
The strike test and method should look almost exactly like the spare test/method. 

The main difference is that a strike takes up a single frame (2 rolls) while a spare is a sum of two rolls.

How a strike works:

[10, 3, 6]

[10 + ((index + 1) + ((index + 2))] [(index + 1) + (index + 2)]
Frame 1															Frame 2

Once frame one has been totaled, instead of incrementing 2 it should just move to the next element, so that index 1 can be added to index 2 (as opposed to index 2 being added to index 3)

Which means for strikes index += 1, but for spares and normal scoring index += 2

All my tests pass.

**IRB Bug**

Playing with the game in IRB I've run into a problem. Although my spare test originally worked, the game was returning incorrect scores so I went back and looked at my test.

I'd made a calculating error and need to figure out how to make that test pass correctly.

Currently, if a player rolls 5, then 5 again, and then 5 again the code calculates a total_score of 20 when it should be 15.

I think this indicates the code is counting one extra 5 at some point. 

What is the spare block of the total_score method doing?

**elsif spare?(index)** --> if spare?(index) is true, which is short for asking if 
@scoreboard[index] + @scoreboard[index + 1] == 10, then do the following

**result += scoring_spare(index)**

@scoreboard[index] + @scoreboard[index + 1] + @scoreboard[index + 2]
[       5         ,           5             ,        5             ] which is 5 + 5 + 5 or 15

**index += 2**

Should effectively jump to the @scoreboard[2] but I don't think it's doing that. 

To be returning a total_score of 20 my guess is that the code is actually doing something like this:

(@scoreboard[0] + @scoreboard[1]) + (@scoreboard[1] + @scoreboard[2]) == 20

Perhaps it isn't jumping to @scoreboard[2] it's jumping to the second element in the array which is @scoreboard[1]. So if I change 

@scoreboard[index] + @scoreboard[index + 1] + @scoreboard[index + 2] 

to 

@scoreboard[index] + @scoreboard[index + 1] + @scoreboard[index + 3]

That should fix the problem by telling the comptuer to move to @scoreboard[2] which is the third element in the array.

And my test passes and it works in IRB.



