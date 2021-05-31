const showMoreCriteria = () => {
  const clickableArrow = document.querySelector("#clickable-arrow");
  const criteria = document.querySelector("#home-checkboxes");

  clickableArrow.addEventListener("click", (event) => {
      criteria.classList.toggle("hidden");
      if (criteria.classList.value === "checkboxes") {
        clickableArrow.classList.value = "fas fa-sort-up"
      } else {
        clickableArrow.classList.value = "fas fa-sort-down"
      }
  });
};

export { showMoreCriteria };
