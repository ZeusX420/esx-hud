
document.body.style.backgroundColor = 'transparent';
document.body.style.overflow = 'hidden';


let health = 100, armor = 0, hunger = 100, thirst = 100;
let currentStreet = "Unknown Street";
let isTalking = false;


const updateBar = (type, value) => {
    const fillElement = document.getElementById(`${type}-fill`);
    const valueElement = document.getElementById(`${type}-value`);
    
    if (fillElement) fillElement.style.transform = `scaleX(${value/100})`;
    if (valueElement) valueElement.textContent = Math.round(value);
};


const updateVoiceState = (talking) => {
    isTalking = talking;
    if (talking) {
        document.getElementById('voice-talking').style.display = 'flex';
        document.getElementById('voice-not-talking').style.display = 'none';
    } else {
        document.getElementById('voice-talking').style.display = 'none';
        document.getElementById('voice-not-talking').style.display = 'flex';
    }
};


window.addEventListener('message', (event) => {
    const data = event.data;
    
    switch(data.type) {
        case 'UPDATE_HUD':
            if (data.health !== undefined) updateBar('health', data.health);
            if (data.armor !== undefined) updateBar('armor', data.armor);
            if (data.hunger !== undefined) updateBar('hunger', data.hunger);
            if (data.thirst !== undefined) updateBar('thirst', data.thirst);
            if (data.street !== undefined) {
                currentStreet = data.street;
                document.getElementById('street-name').textContent = currentStreet;
            }
            break;
            
        case 'UPDATE_VOICE':
            updateVoiceState(data.talking);
            break;
            
        case 'HIDE_HUD':
            document.getElementById('hud-container').style.display = 'none';
            document.getElementById('info-container').style.display = 'none';
            document.querySelector('.voice-container').style.display = 'none';
            break;
            
        case 'SHOW_HUD':
            document.getElementById('hud-container').style.display = 'flex';
            document.getElementById('info-container').style.display = 'flex';
            document.querySelector('.voice-container').style.display = 'flex';
            
            updateVoiceState(isTalking);
            break;
    }
});


const updateDateTime = () => {
    const now = new Date();
    document.getElementById('time').textContent = now.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
    document.getElementById('date').textContent = now.toLocaleDateString([], {day: '2-digit', month: '2-digit', year: 'numeric'});
    setTimeout(updateDateTime, 1000);
};


updateDateTime();
updateVoiceState(false); 


window.addEventListener('load', () => {
    if ('GetParentResourceName' in window) {
        fetch(`https://${GetParentResourceName()}/UI_READY`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ready: true})
        });
    }
});