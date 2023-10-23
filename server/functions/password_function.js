function generatePassword(name, dob) {
    // Extract the first three letters of the name
    const namePart = name.slice(0, 3).toLowerCase(); // Ensure it's in lowercase
  
    // Extract the day and month from the date of birth
    const dobPart = dob.split('-').slice(0, 2).join('');
  
    // Combine the name and date of birth parts to create the password
    const password = namePart + dobPart;
  
    return password;
  }