// Fill out your copyright notice in the Description page of Project Settings.


#include "HelperActor/UIInputActor.h"

// Sets default values
AUIInputActor::AUIInputActor()
{
 	// Set this actor to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;
	//InputComponent = NewObject<UEnhancedInputComponent>();
	//InputComponent->RegisterComponent();
	//InputComponent->bBlockInput = bBlockInput;
	//InputComponent->Priority = InputPriority;
}

// Called when the game starts or when spawned
void AUIInputActor::BeginPlay()
{
	Super::BeginPlay();
	
}

// Called every frame
void AUIInputActor::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);

}

void AUIInputActor::EnableInput(APlayerController* PlayerController)
{
	if (PlayerController)
	{
		// If it doesn't exist create it and bind delegates
		if (!InputComponent)
		{
			InputComponent = NewObject<UEnhancedInputComponent>(PlayerController);
			InputComponent->RegisterComponent();
			InputComponent->bBlockInput = bBlockInput;
			InputComponent->Priority = InputPriority;
			// UInputDelegateBinding::BindInputDelegatesWithSubojects(this, InputComponent);
		}
		else
		{
			// Make sure we only have one instance of the InputComponent on the stack
			PlayerController->PopInputComponent(InputComponent);
		}

		PlayerController->PushInputComponent(InputComponent);
	}
}

//void AUIInputActor::BindUIAction(FString ActionName, EInputEvent TriggerEvent, UObject* Object, FInputActionHandlerSignature::TMethodPtr< UObject > Func)
//{
//	if (InputComponent) {
//		// InputComponent->BindAction("RoundPlanetPawn_IncreaseSpeedScalar", IE_Pressed, this, Func);
//		InputComponent->BindAction(*ActionName, TriggerEvent, Object, Func);
//	}
//}

void AUIInputActor::ShowPrevEntry()
{
}
