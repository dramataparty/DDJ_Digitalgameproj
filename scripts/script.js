//alters how the mouse cursor functions on the page in order to progress the game
//current ideas: 1 - able to drag objects/page elements to solve puzzles and reveal clues hidden behind said objects/page elements
//2 - flashlght effect that reveals hidden messages or clues when the user moves the mouse around the screen
//3 - hammer effect that lets the user "break" certain page elements

function mousemod() {
  //basic implementation for flashlght effect
  document.addEventListener('mousemove', function(e) {
    //get the mouse position
    var mouseX = e.clientX;
    var mouseY = e.clientY;

    //check if the mouse is over a certain element
    var element = document.elementFromPoint(mouseX, mouseY);

    //if the element has a class of "flashlight", reveal the hidden message
    if (element.classList.contains("flashlight")) {
      element.style.opacity = "1";
      setTimeout(function() {
        element.style.opacity = "0";
      }, 500);
    }
  });
}
