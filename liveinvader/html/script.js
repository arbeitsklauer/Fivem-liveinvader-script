const app = document.getElementById('app');
const closeBtn = document.getElementById('close-btn');
const adInput = document.getElementById('ad-input');
const costDisplay = document.getElementById('current-cost');
const btnCash = document.getElementById('send-btn-cash');
const btnCard = document.getElementById('send-btn-card');
const adList = document.getElementById('ad-list');
const notificationContainer = document.getElementById('notification-container');

let costPerChar = 5;

window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.type === "toggleUI") {
        if (data.status) {
            app.style.display = "flex";
            adInput.focus();
        } else {
            app.style.display = "none";
        }
    }

    if (data.type === "notification") {
        createNotification(data.title, data.message, data.style);
    }

    if (data.type === "addAd") {
        addAdToList(data.name, data.message);
    }
});

adInput.addEventListener('input', () => {
    const textLength = adInput.value.length;
    const totalCost = textLength * costPerChar;
    costDisplay.innerText = `${totalCost}$`;
});

btnCash.addEventListener('click', () => sendAdvertisement('money'));
btnCard.addEventListener('click', () => sendAdvertisement('bank'));

function sendAdvertisement(paymentMethod) {
    const message = adInput.value;
    if (message.trim().length === 0) return;

    fetch(`https://${GetParentResourceName()}/sendAd`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({ message: message, paymentMethod: paymentMethod })
    }).then(resp => resp.json()).then(resp => {
        if (resp === "ok") {
            adInput.value = "";
            costDisplay.innerText = "0$";
        }
    });
}

closeBtn.addEventListener('click', () => {
    fetch(`https://${GetParentResourceName()}/closeUI`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({})
    });
});

function addAdToList(name, message) {
    const adItem = document.createElement('div');
    adItem.className = 'ad-item';
    adItem.innerHTML = `
        <div class="ad-user">${name}</div>
        <div class="ad-text">${message}</div>
    `;
    adList.prepend(adItem);

    if (adList.children.length > 5) adList.lastElementChild.remove();
}

function createNotification(title, message, style) {
    const notify = document.createElement('div');
    notify.className = `notification ${style}`;

    // Split message into Name and Text (Expected format "Name: Message")
    let name = "Anzeige";
    let text = message;

    if (message.indexOf(':') !== -1) {
        const splitIdx = message.indexOf(':');
        name = message.substring(0, splitIdx).trim();
        text = message.substring(splitIdx + 1).trim();
    }

    notify.innerHTML = `
        <div class="notification-divider"></div>
        <div class="notification-content">
            <div class="notification-header">${title}</div>
            <div class="notification-name">${name}</div>
            <div class="notification-text">${text}</div>
        </div>
    `;

    notificationContainer.appendChild(notify);

    setTimeout(() => {
        notify.style.animation = "slideInLeft 0.4s reverse forwards";
        setTimeout(() => notify.remove(), 400);
    }, 8000);
}

window.addEventListener('keydown', (e) => {
    if (e.key === "Escape") closeBtn.click();
});
