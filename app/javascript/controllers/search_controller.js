import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [
    "startCity",
    "supermarket",
    "commodity",
    "primarySchool",
    "secondarySchool",
    "fibre",
    "network",
    "doctor",
    "handiwork",
    "grocery",
    "butchery",
    "bakery",
    "bookstore",
    "clothe",
    "shoestore",
    "fish_market",
    "it",
    "hardware",
    "jewellery",
    "cosmetic",
    "optic",
    "plant",
    "maxDistanceKm",
    "maxPopulation",
    "maxAgeAverage",
    "favorites"
  ]
  connect() {
    const query = this.buildQuery()
    this.favoritesTarget.dataset.query = query
  }

  navigate() {
    const query = this.buildQuery()
    const url = `/cities${query}`
    window.location = url
  }

  buildQuery() {
    const supermarket = this.supermarketTarget.checked ? 'supermarket=1' : ''

    const city = `location[name]=${this.startCityTarget.value}`

    const maxDisKm = `location[max_distance_km]=${this.maxDistanceKmTarget.value}`

    const com = this.commodityTarget.checked ? 'commodity=1' : ''

    const primary = this.primarySchoolTarget.checked ? 'primary_school=1' : ''

    const secondary = this.secondarySchoolTarget.checked ? 'secondary_school=1' : ''

    const fibre = this.fibreTarget.checked ? 'fibre=1' : ''

    const network = this.networkTarget.checked ? 'network=1' : ''

    const doctor = this.doctorTarget.checked ? 'doctor=1' : ''

    const handiwork = this.handiworkTarget.checked ? 'handiwork=1' : ''

    const grocery = this.groceryTarget.checked ? 'grocery=1' : ''

    const butchery = this.butcheryTarget.checked ? 'butchery=1' : ''

    const bakery = this.bakeryTarget.checked ? 'bakery=1' : ''

    const bookstore = this.bookstoreTarget.checked ? 'bookstore=1' : ''

    const clothe = this.clotheTarget.checked ? 'clothe=1' : ''

    const shoestore = this.shoestoreTarget.checked ? 'shoestore=1' : ''

    const fish_market = this.fish_marketTarget.checked ? 'fish_market=1' : ''

    const it = this.itTarget.checked ? 'it=1' : ''

    const hardware = this.hardwareTarget.checked ? 'hardware=1' : ''

    const jewellery = this.jewelleryTarget.checked ? 'jewellery=1' : ''

    const cosmetic = this.cosmeticTarget.checked ? 'cosmetic=1' : ''

    const optic = this.opticTarget.checked ? 'optic=1' : ''

    const plant = this.plantTarget.checked ? 'plant=1' : ''

    const max_population = this.maxPopulationTarget.value === undefined ? '' : `max_population=${this.maxPopulationTarget.value}`

    const max_age_average = this.maxAgeAverageTarget.value === undefined ? '' : `max_age_average=${this.maxAgeAverageTarget.value}`

    const query = `?${city}&${maxDisKm}&${com}&${primary}&${secondary}&${fibre}&${network}\
                   &${doctor}&${handiwork}&${grocery}&${butchery}&${bakery}&${bookstore}\
                   &${shoestore}&${clothe}&${fish_market}&${jewellery}&${cosmetic}&${hardware}&${supermarket}&${max_population}\
                   &${it}&${plant}&${optic}/
                   &${max_age_average}`

    return query
  }
}
