
Inch is a command-line tool that gives you hints where to improve your Ruby docs. One Inch at a time.

## No coverage percentages

Inch does not measure documentation *coverage*. It does not tell you to document all your code. Neither does it tell you not to.




## Grades & Priorities

<div class="screenshot">
  <div style="height: 90px; background-image: url(/public/images/quickstart-optparse.png); background-position: 0 -322px;"></div>
</div>

Inch assigns grades (`A`,`B`,`C`) to each class, module, constant or method in a codebase. It also assigns a special grade (`U`) to undocumented objects.

Afterwards, it calculates a priority for each of these objects. The priorities are represented by arrows and based on simple assumptions like *"public methods are more important to document than private ones"*.



## Grade distribution

At the end of the "report", Inch shows the distribution of grades:

<div class="screenshot">
  <div style="height: 20px; background-image: url(/public/images/quickstart-optparse.png); background-position: 0 -520px;"></div>
</div>

This provides a lot more insight than an overall grade could. In this example:

* There is a significant amount of documented code.
* The present documentation seems good.
* There are still some undocumented methods.

Inch shows this without judging. This way, it is perfectly reasonable to leave *parts* of the codebase undocumented.


