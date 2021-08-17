export const getMockClinics = () => {
    let clinics = []
    for (let i = 0; i < 50; i++) {
        let clinic = {
            clinicId: String(getRandomInt(1, 10000)),
            checkUpId: String(getRandomInt(1, 10000)),
            price: String(getRandomInt(500, 80000)),
            lat: Number(55 + '.' + getRandomInt(1, 1000000)),
            lon: Number(37 + '.' + getRandomInt(1, 1000000)),
        }
        console.log(clinic);

        clinics.push(clinic)
    }
    return clinics
}


function getRandomInt(min: number, max: number) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min;
}