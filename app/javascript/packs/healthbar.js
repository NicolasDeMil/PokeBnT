let health = document.getElementById("health")

const playerOneMoves = document.querySelectorAll(".player-one");
const playerTwoMoves = document.querySelectorAll(".player-two");

const healthBarPlayerOne = document.getElementById("health-player-one");
const healthBarPlayerTwo = document.getElementById("health-player-two");




const enemyMoveOne = document.getElementById("pokemon-two-name").dataset.moveone;

const enemyMoveTwo = document.getElementById("pokemon-two-name").dataset.movetwo;

const enemyMoves = [enemyMoveOne, enemyMoveTwo];

const attackMove = () => {
  playerOneMoves.forEach((move) => {
  move.addEventListener('click', () => {

    // Player One Move
    let hpPokemonTwo = document.getElementById("pokemon-two-name").dataset.hp;
    var updateHp = hpPokemonTwo - move.dataset.movevalue;

    var newHp = updateHp * 100 / hpPokemonTwo ;

    healthBarPlayerTwo.setAttribute("value", newHp);
    document.getElementById("pokemon-two-name").setAttribute("data-hp", newHp);

    // Player Two Move
    const hpPokemonOne = document.getElementById("pokemon-one-name").dataset.hp;
    var updateHpOne = hpPokemonOne - randomItem(enemyMoves);
    var newHpOne = updateHpOne * 100 / hpPokemonOne ;
    healthBarPlayerOne.setAttribute("value", newHpOne);
    document.getElementById("pokemon-one-name").setAttribute("data-hp", newHpOne);

    var finalMessage = document.querySelector(".final-message")
    var pageCover = document.querySelector(".page-cover")

    if (healthBarPlayerOne.getAttribute("value") <= 0) {
    window.alert("Oh no! You have not won this one.")
    // finalMessage.style.display = "block";
    // pageCover.style.display = "block";
    // finalMessage.innerHTML = "<p>You have won<p>"
    } else if (healthBarPlayerTwo.getAttribute("value") <= 0) {
    window.alert("Congratulations! You are a winner!")
    // finalMessage.style.display = "block";
    // pageCover.style.display = "block";
    // finalMessage.innerHTML = "<p>You have lost<p>"
    };

  });

  });

};

const randomItem = (items) => {
  return items[Math.floor(Math.random()*items.length)];
}

export { attackMove };


